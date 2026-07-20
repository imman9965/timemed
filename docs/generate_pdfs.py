#!/usr/bin/env python3
"""Convert TimesMed Markdown docs to professional PDFs."""

from __future__ import annotations

import re
import sys
from pathlib import Path

import markdown
from fpdf import FPDF
from fpdf.enums import XPos, YPos

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"
FONTS = Path(r"C:\Windows\Fonts")

# Prefer fonts that cover Latin + common symbols
FONT_REGULAR = next(
    (FONTS / n for n in ("arial.ttf", "calibri.ttf", "segoeui.ttf") if (FONTS / n).exists()),
    None,
)
FONT_BOLD = next(
    (FONTS / n for n in ("arialbd.ttf", "calibrib.ttf", "segoeuib.ttf") if (FONTS / n).exists()),
    None,
)
FONT_MONO = next(
    (FONTS / n for n in ("consola.ttf", "cour.ttf") if (FONTS / n).exists()),
    None,
)


def sanitize(text: str) -> str:
    """Replace characters that commonly break PDF fonts."""
    replacements = {
        "\u2014": "-",
        "\u2013": "-",
        "\u2018": "'",
        "\u2019": "'",
        "\u201c": '"',
        "\u201d": '"',
        "\u2026": "...",
        "\u00a0": " ",
        "\u2022": "-",
        "\u2192": "->",
        "\u2190": "<-",
        "\u2194": "<->",
        "\u2713": "[x]",
        "\u2610": "[ ]",
        "\u2611": "[x]",
        "\u2500": "-",
        "\u2502": "|",
        "\u2514": "+",
        "\u251c": "+",
        "\u252c": "+",
        "\u2534": "+",
        "\u253c": "+",
        "\u2550": "=",
        "\u25b6": ">",
        "\u25cf": "*",
        "\u25cb": "o",
        "\u20b9": "INR ",
        "\u200b": "",
        "\ufeff": "",
        "🔹": "",
        "🔥": "",
        "🔵": "",
        "🧑‍⚕️": "",
        "✅": "[OK]",
        "❌": "[X]",
        "⚠️": "[WARN]",
        "📌": "",
        "💰": "",
        "📋": "",
        "🩺": "",
        "📱": "",
        "🔐": "",
        "📊": "",
        "🧾": "",
        "🏥": "",
        "💊": "",
        "🧪": "",
        "📞": "",
        "🎥": "",
        "⭐": "*",
        "∈": "in",
        "\u2208": "in",
        "←": "<-",
        "↔": "<->",
        "≥": ">=",
        "≤": "<=",
        "×": "x",
        "•": "-",
        "–": "-",
        "—": "-",
        "₹": "INR ",
    }
    for src, dst in replacements.items():
        text = text.replace(src, dst)
    # Drop remaining non-BMP / unsupported control chars
    out = []
    for ch in text:
        o = ord(ch)
        if ch in "\n\t\r":
            out.append(ch)
        elif 32 <= o < 0x10000:
            out.append(ch)
        else:
            out.append("?")
    return "".join(out)


class DocPDF(FPDF):
    def __init__(self, title: str):
        super().__init__(format="A4", unit="mm")
        self.doc_title = title
        self.set_auto_page_break(auto=True, margin=16)
        self.set_margins(14, 16, 14)
        if FONT_REGULAR and FONT_BOLD:
            self.add_font("Body", "", str(FONT_REGULAR))
            self.add_font("Body", "B", str(FONT_BOLD))
            self.body_font = "Body"
        else:
            self.body_font = "Helvetica"
        if FONT_MONO:
            self.add_font("Mono", "", str(FONT_MONO))
            self.code_font = "Mono"
        else:
            self.code_font = "Courier"

    def header(self):
        if self.page_no() == 1:
            return
        self.set_font(self.body_font, "B", 8)
        self.set_text_color(6, 115, 222)
        self.cell(0, 6, self.doc_title, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.set_draw_color(6, 115, 222)
        self.line(14, self.get_y(), 196, self.get_y())
        self.ln(4)

    def footer(self):
        self.set_y(-12)
        self.set_font(self.body_font, "", 8)
        self.set_text_color(120, 120, 120)
        self.cell(0, 8, f"Page {self.page_no()}/{{nb}}", align="C")


def parse_table(lines: list[str], start: int) -> tuple[list[list[str]], int]:
    rows = []
    i = start
    while i < len(lines) and lines[i].strip().startswith("|"):
        row = [c.strip() for c in lines[i].strip().strip("|").split("|")]
        # skip separator row
        if all(re.fullmatch(r":?-{3,}:?", c.replace(" ", "")) for c in row):
            i += 1
            continue
        rows.append([sanitize(c) for c in row])
        i += 1
    return rows, i


def draw_table(pdf: DocPDF, rows: list[list[str]]):
    if not rows:
        return
    cols = max(len(r) for r in rows)
    usable = pdf.epw
    col_w = usable / cols
    pdf.set_font(pdf.body_font, "B", 8)
    for r_i, row in enumerate(rows):
        # estimate row height
        pdf.set_font(pdf.body_font, "B" if r_i == 0 else "", 8)
        cell_lines = []
        max_h = 6
        for c in range(cols):
            text = row[c] if c < len(row) else ""
            # wrap estimate
            lines = pdf.multi_cell(col_w - 2, 4, text, dry_run=True, output="LINES")
            cell_lines.append(lines)
            max_h = max(max_h, 4 * len(lines) + 2)
        if pdf.get_y() + max_h > pdf.page_break_trigger:
            pdf.add_page()
        y0 = pdf.get_y()
        x0 = pdf.get_x()
        for c in range(cols):
            x = x0 + c * col_w
            pdf.set_xy(x, y0)
            if r_i == 0:
                pdf.set_fill_color(232, 241, 252)
                pdf.set_text_color(11, 79, 138)
                pdf.set_font(pdf.body_font, "B", 8)
            else:
                if r_i % 2 == 0:
                    pdf.set_fill_color(247, 249, 252)
                else:
                    pdf.set_fill_color(255, 255, 255)
                pdf.set_text_color(30, 30, 30)
                pdf.set_font(pdf.body_font, "", 8)
            pdf.rect(x, y0, col_w, max_h, style="DF")
            pdf.set_xy(x + 1, y0 + 1)
            pdf.multi_cell(col_w - 2, 4, "\n".join(cell_lines[c]))
        pdf.set_y(y0 + max_h)
        pdf.set_x(pdf.l_margin)
    pdf.ln(3)
    pdf.set_x(pdf.l_margin)
    pdf.set_text_color(30, 30, 30)


def safe_text(pdf: DocPDF, text: str, size: float = 10, bold: bool = False, color=(30, 30, 30), h: float = 5):
    pdf.set_x(pdf.l_margin)
    pdf.set_font(pdf.body_font, "B" if bold else "", size)
    pdf.set_text_color(*color)
    pdf.multi_cell(pdf.epw, h, text)
    pdf.set_text_color(30, 30, 30)


def render_markdown(pdf: DocPDF, md_text: str):
    lines = md_text.splitlines()
    i = 0
    in_code = False
    code_lang = ""
    code_buf: list[str] = []

    def flush_code():
        nonlocal code_buf, code_lang
        if not code_buf:
            return
        label = code_lang.strip() or "code"
        if label.lower() == "mermaid":
            safe_text(
                pdf,
                "[Mermaid diagram — see source Markdown for editable flow]",
                size=9,
                bold=True,
                color=(11, 79, 138),
            )
        pdf.set_fill_color(244, 247, 251)
        pdf.set_font(pdf.code_font, "", 7.5)
        block = sanitize("\n".join(code_buf))
        for chunk_line in block.split("\n"):
            if pdf.get_y() > pdf.page_break_trigger - 8:
                pdf.add_page()
            pdf.set_x(pdf.l_margin)
            pdf.multi_cell(pdf.epw, 4, chunk_line if chunk_line else " ", fill=True)
        pdf.ln(2)
        pdf.set_font(pdf.body_font, "", 10)
        code_buf = []
        code_lang = ""

    while i < len(lines):
        raw = lines[i]
        line = raw.rstrip("\n")

        if line.strip().startswith("```"):
            if not in_code:
                in_code = True
                code_lang = line.strip()[3:]
                code_buf = []
            else:
                in_code = False
                flush_code()
            i += 1
            continue

        if in_code:
            code_buf.append(line)
            i += 1
            continue

        if line.strip().startswith("|") and i + 1 < len(lines) and re.search(r"\|\s*-{3,}", lines[i + 1]):
            rows, i = parse_table(lines, i)
            draw_table(pdf, rows)
            continue

        s = line.strip()
        if not s:
            pdf.ln(2)
            i += 1
            continue

        if s.startswith("# "):
            safe_text(pdf, sanitize(s[2:]), size=16, bold=True, color=(6, 115, 222), h=8)
            pdf.set_draw_color(6, 115, 222)
            y = pdf.get_y()
            pdf.line(14, y, 196, y)
            pdf.ln(4)
        elif s.startswith("## "):
            if pdf.get_y() > 250:
                pdf.add_page()
            safe_text(pdf, sanitize(s[3:]), size=13, bold=True, color=(11, 79, 138), h=7)
            pdf.ln(1)
        elif s.startswith("### "):
            safe_text(pdf, sanitize(s[4:]), size=11.5, bold=True, color=(21, 90, 138), h=6)
            pdf.ln(1)
        elif s.startswith("#### "):
            safe_text(pdf, sanitize(s[5:]), size=10.5, bold=True, h=5.5)
            pdf.ln(0.5)
        elif s.startswith("---"):
            pdf.ln(2)
            pdf.set_draw_color(200, 210, 220)
            y = pdf.get_y()
            pdf.line(14, y, 196, y)
            pdf.ln(3)
        elif s.startswith("> "):
            pdf.set_fill_color(240, 247, 255)
            pdf.set_x(pdf.l_margin)
            pdf.set_font(pdf.body_font, "", 9.5)
            pdf.multi_cell(pdf.epw, 5, sanitize(s[2:]), fill=True)
            pdf.ln(1)
        elif s.startswith("- [ ] ") or s.startswith("- [x] ") or s.startswith("- [X] "):
            mark = "[ ]" if "[ ]" in s[:6] else "[x]"
            safe_text(pdf, sanitize(f"  {mark} {s[6:]}"), size=10)
        elif s.startswith("- ") or s.startswith("* "):
            safe_text(pdf, sanitize(f"  - {s[2:]}"), size=10)
        elif re.match(r"^\d+\.\s+", s):
            safe_text(pdf, sanitize(f"  {s}"), size=10)
        else:
            text = sanitize(s)
            text = re.sub(r"\*\*(.+?)\*\*", r"\1", text)
            text = re.sub(r"`([^`]+)`", r"\1", text)
            text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
            safe_text(pdf, text, size=10)
        i += 1


def md_to_pdf(md_path: Path, pdf_path: Path, title: str):
    md_text = md_path.read_text(encoding="utf-8")
    pdf = DocPDF(title=title)
    pdf.alias_nb_pages()
    pdf.add_page()

    # Cover block
    pdf.set_x(pdf.l_margin)
    pdf.set_font(pdf.body_font, "B", 20)
    pdf.set_text_color(6, 115, 222)
    pdf.multi_cell(pdf.epw, 10, title, align="C")
    pdf.ln(2)
    pdf.set_x(pdf.l_margin)
    pdf.set_font(pdf.body_font, "", 11)
    pdf.set_text_color(80, 80, 80)
    pdf.multi_cell(pdf.epw, 6, "TimesMed Health Care", align="C")
    pdf.set_x(pdf.l_margin)
    pdf.multi_cell(pdf.epw, 6, "Generated from project documentation", align="C")
    pdf.set_x(pdf.l_margin)
    pdf.multi_cell(pdf.epw, 6, "Date: 20 July 2026  |  Doc version 3.0", align="C")
    pdf.ln(4)
    pdf.set_draw_color(6, 115, 222)
    y = pdf.get_y()
    pdf.line(40, y, 170, y)
    pdf.ln(8)
    pdf.set_x(pdf.l_margin)
    pdf.set_text_color(30, 30, 30)

    render_markdown(pdf, md_text)
    pdf.output(str(pdf_path))
    print(f"Wrote {pdf_path} ({pdf_path.stat().st_size // 1024} KB, {pdf.page_no()} pages)")


def main():
    jobs = [
        (
            DOCS / "APP_FLOW.md",
            DOCS / "TimesMed_Application_Flow.pdf",
            "TimesMed — Application Flow Documentation",
        ),
        (
            DOCS / "BACKEND_REQUIREMENTS_SPECIFICATION.md",
            DOCS / "TimesMed_Backend_Requirements_Specification.pdf",
            "TimesMed — Backend Requirement Specification (BRS)",
        ),
    ]
    for md, pdf, title in jobs:
        if not md.exists():
            print(f"Missing: {md}", file=sys.stderr)
            continue
        md_to_pdf(md, pdf, title)


if __name__ == "__main__":
    main()
