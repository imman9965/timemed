import 'dart:io';
import 'dart:typed_data';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';

class MedicalPdfHelper {
  /// Generate Prescription PDF
  static Future<Uint8List> generatePrescriptionPdf(MedicalRecordModel record) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader("PRESCRIPTION", record),
              pw.SizedBox(height: 20),
              _buildSectionTitle("Patient Details"),
              pw.Text("Name: ${record.patientName}"),
              pw.Text("Visit ID: ${record.visitId}"),
              pw.Text("Date: ${record.date}"),
              pw.SizedBox(height: 20),
              _buildSectionTitle("Medicines"),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Medicine', 'Frequency', 'Days', 'Instructions'],
                data: record.prescriptions.map((p) {
                  return [p.medicineName, p.frequency, p.days.toString(), p.instructions];
                }).toList(),
              ),
              pw.SizedBox(height: 30),
              if (record.notes.isNotEmpty) ...[
                _buildSectionTitle("Doctor's Notes"),
                pw.Text(record.notes),
              ],
              pw.Spacer(),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  children: [
                    pw.Text(record.doctorName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(record.speciality),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Generate Lab Report PDF
  static Future<Uint8List> generateLabReportPdf(MedicalRecordModel record) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader("LAB REPORT", record),
              pw.SizedBox(height: 20),
              _buildSectionTitle("Patient Details"),
              pw.Text("Name: ${record.patientName}"),
              pw.Text("Visit ID: ${record.visitId}"),
              pw.Text("Date: ${record.date}"),
              pw.SizedBox(height: 20),
              _buildSectionTitle("Requested Tests"),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Test Name', 'Category', 'Instructions'],
                data: record.labTests.map((lab) {
                  return [lab.testName, lab.category, lab.instructions];
                }).toList(),
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  children: [
                    pw.Text(record.doctorName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(record.speciality),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(String title, MedicalRecordModel record) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Text("TimesMed Healthcare", style: pw.TextStyle(color: PdfColors.grey)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(record.doctorName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(record.speciality),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
    );
  }

  /// Save and Open PDF
  static Future<void> saveAndOpenPdf(Uint8List bytes, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);
    } catch (e) {
      print("Error saving or opening PDF: $e");
    }
  }
}
