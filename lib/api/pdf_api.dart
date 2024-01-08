// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdf/widgets.dart' as pw;

import '../loan_model/loan_model.dart';

class PdfApi {
  static Future<void> generatePdfForLoan(String loanDocumentId) async {
    final DocumentSnapshot<Map<String, dynamic>> loanSnapshot =
        await FirebaseFirestore.instance
            .collection('Loan')
            .doc(loanDocumentId)
            .get();

    if (!loanSnapshot.exists) {
      print('Loan document does not exist!');
      return;
    }

    final LoanModel loan = LoanModel.fromSnapshot(loanSnapshot);
    final logoUrl = loan.logo;
    final logoRef = FirebaseStorage.instance.ref().child(logoUrl);
    final logoBytes = await logoRef.getData();
    final userImageRef = FirebaseStorage.instance.ref().child(loan.userImage);
    final userImageBytes = await userImageRef.getData();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
          build: (context) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      width: 150.0,
                      height: 150.0,
                      decoration: const pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Image(pw.MemoryImage(logoBytes!)),
                    ),
                    pw.Text(
                      'Loan Details',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 20),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      width: 120.0,
                      height: 150.0,
                      decoration: const pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Image(
                        pw.MemoryImage(userImageBytes!),
                        width: 120.0,
                        height: 150.0,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(1),
                        1: const pw.FlexColumnWidth(2),
                      },
                      children: [
                        _buildTableRow('User Name', loan.userName),
                        _buildTableRow('Loan Type', loan.loanType),
                        _buildTableRow('Phone Number', loan.phone),
                        _buildTableRow('Pan Number', loan.panNoCpy),
                        _buildTableRow('Aadhar Number', loan.aadharNo),
                        _buildTableRow('DOB', loan.date.toString()),
                        _buildTableRow('Address', loan.address),
                        _buildTableRow('Pin Code', loan.pin),
                        _buildTableRow('Nationality', loan.nationality),
                        _buildTableRow('Email', loan.email),
                        _buildTableRow('Employee Type', loan.empType),
                        _buildTableRow('Income', loan.combinedIncome),
                      ],
                    ),
                  ])),
    );

    final imageUrls = [
      loan.panImg,
      loan.aadharImg,
      loan.bankImg,
      loan.secondImg,
      loan.itReturnImg,
      loan.form16img,
    ];

    final textLabels = [
      'PAN Image',
      'Aadhar Image',
      'Bank Image',
      'Second Image',
      'IT Return Image',
      'Form 16 Image',
    ];

    for (int i = 0; i < imageUrls.length; i++) {
      final imageUrl = imageUrls[i];
      final imageRef = FirebaseStorage.instance.ref().child(imageUrl);
      final imageBytes = await imageRef.getData();

      pdf.addPage(pw.Page(
        build: (context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              textLabels[i],
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 22),
            ),
            pw.SizedBox(height: 25),
            pw.Center(
              child: pw.Container(
                width: 300.0,
                height: 350.0,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Image(pw.MemoryImage(imageBytes!)),
              ),
            ),
          ],
        ),
      ));
    }
    final Uint8List pdfBytes = await pdf.save();
    final blob = html.Blob([pdfBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = 'loan_data.pdf'
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  static pw.TableRow _buildTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value),
        ),
      ],
    );
  }
}
