import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';
import 'dummy_data_5.dart';

// ════════════════════════════════════════════════════════
//  PAINTER — renders freehand strokes
// ════════════════════════════════════════════════════════
class SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  final double strokeWidth;

  /// When true, the strokes are scaled + centered to fit the paint box
  /// (used for the small read-only previews so the signature never overflows).
  final bool fit;

  SignaturePainter(
    this.strokes, {
    this.color = DoctorColors.textDark,
    this.strokeWidth = 2.5,
    this.fit = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final all = <Offset>[for (final s in strokes) ...s];
    if (all.isEmpty) return;

    // Build a transform that fits the signature inside [size] with padding.
    Offset Function(Offset) map = (p) => p;
    if (fit) {
      double minX = all.first.dx, maxX = minX, minY = all.first.dy, maxY = minY;
      for (final p in all) {
        minX = math.min(minX, p.dx);
        maxX = math.max(maxX, p.dx);
        minY = math.min(minY, p.dy);
        maxY = math.max(maxY, p.dy);
      }
      const pad = 4.0;
      final bw = maxX - minX, bh = maxY - minY;
      final availW = size.width - pad * 2, availH = size.height - pad * 2;
      final sx = bw > 0 ? availW / bw : double.infinity;
      final sy = bh > 0 ? availH / bh : double.infinity;
      var scale = math.min(sx, sy);
      if (!scale.isFinite || scale <= 0) scale = 1.0;
      final ox = pad + (availW - bw * scale) / 2;
      final oy = pad + (availH - bh * scale) / 2;
      map = (p) => Offset(ox + (p.dx - minX) * scale, oy + (p.dy - minY) * scale);
    }

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        canvas.drawCircle(
            map(stroke.first), strokeWidth / 2, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
        continue;
      }
      final p0 = map(stroke.first);
      final path = Path()..moveTo(p0.dx, p0.dy);
      for (var i = 1; i < stroke.length; i++) {
        final q = map(stroke[i]);
        path.lineTo(q.dx, q.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) => true;
}

// ════════════════════════════════════════════════════════
//  DRAWABLE PAD — used on the Basic Details form
// ════════════════════════════════════════════════════════
class SignaturePad extends StatefulWidget {
  /// Defaults to the shared [doctorSignature] store.
  final DoctorSignatureData? data;
  final double height;

  const SignaturePad({super.key, this.data, this.height = 170});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  DoctorSignatureData get _data => widget.data ?? doctorSignature;

  void _startStroke(Offset p) => setState(() => _data.strokes.add([p]));

  void _appendPoint(Offset p) => setState(() {
        if (_data.strokes.isEmpty) _data.strokes.add(<Offset>[]);
        _data.strokes.last.add(p);
      });

  void _clear() => setState(_data.clear);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: DoctorColors.inputBg,
            borderRadius: BorderRadius.circular(AppDimens1.radiusMd),
            border: Border.all(color: DoctorColors.divider),
          ),
          child: Stack(
            children: [
              if (!_data.hasDrawing)
                Center(
                  child: Text(
                    'Sign here',
                    style: AppTextStyles.inputHint.copyWith(fontSize: 15),
                  ),
                ),
              Positioned.fill(
                child: GestureDetector(
                  onPanStart: (d) => _startStroke(d.localPosition),
                  onPanUpdate: (d) => _appendPoint(d.localPosition),
                  child: CustomPaint(
                    painter: SignaturePainter(_data.strokes),
                    size: Size.infinite,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens1.s),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _clear,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: DoctorColors.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimens1.radiusMd),
                border: Border.all(color: DoctorColors.errorRed.withOpacity(0.4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_outline, size: 18, color: DoctorColors.errorRed),
                  SizedBox(width: 6),
                  Text('Clear',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: DoctorColors.errorRed)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════
//  READ-ONLY VIEW — shown on the Prescription / template detail
// ════════════════════════════════════════════════════════
class SignatureView extends StatelessWidget {
  /// Defaults to the shared [doctorSignature] store.
  final DoctorSignatureData? data;

  /// When true, prints the doctor name + qualification beneath the signature.
  final bool showName;

  /// When true, wraps the signature in a bordered card.
  final bool bordered;

  const SignatureView({
    super.key,
    this.data,
    this.showName = true,
    this.bordered = true,
  });

  @override
  Widget build(BuildContext context) {
    final sig = data ?? doctorSignature;
    return Container(
      width: double.infinity,
      padding: bordered
          ? const EdgeInsets.fromLTRB(14, 12, 14, 12)
          : EdgeInsets.zero,
      decoration: bordered
          ? BoxDecoration(
              color: DoctorColors.cardWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: DoctorColors.fieldBorder),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 50,
            width: 190,
            child: sig.hasDrawing
                ? ClipRect(
                    child: CustomPaint(
                      painter: SignaturePainter(sig.strokes,
                          strokeWidth: 2, fit: true),
                      size: Size.infinite,
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.draw_outlined,
                      size: 28,
                      color: DoctorColors.textHint,
                    ),
                  ),
          ),
          Container(
            width: 190,
            height: 1.2,
            color: DoctorColors.textPrimary,
            margin: const EdgeInsets.only(top: 2, bottom: 6),
          ),
          if (showName) ...[
            Text(
              sig.doctorName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: DoctorColors.textPrimary,
              ),
            ),
            if (sig.qualification.isNotEmpty)
              Text(
                sig.qualification,
                style: const TextStyle(
                  fontSize: 12,
                  color: DoctorColors.textSecondary,
                ),
              ),
            const SizedBox(height: 2),
          ],
          const Text(
            "Doctor's Signature",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: DoctorColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
