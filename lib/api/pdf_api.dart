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
    final panUrl = loan.panImg;
    final aadharUrl = loan.aadharImg;
    final imageUrl4 = loan.secondImg;
    final imageUrl5 = loan.itReturnImg;
    final imageUrl6 = loan.form16img;
    final imageUrl7 = loan.userImage;
    final panRef = FirebaseStorage.instance.ref().child(panUrl);
    final logoRef = FirebaseStorage.instance.ref().child(logoUrl);
    final addharRef = FirebaseStorage.instance.ref().child(aadharUrl);
    final panBytes = await panRef.getData();
    final logoBytes = await logoRef.getData();
    final aadharBytes = await addharRef.getData();
     final imageRef4 = FirebaseStorage.instance.ref().child(imageUrl4);
    final imageRef5 = FirebaseStorage.instance.ref().child(imageUrl5);
    final imageRef6 = FirebaseStorage.instance.ref().child(imageUrl6);

    final imageRef7 = FirebaseStorage.instance.ref().child(imageUrl7);
    final imageBytes4 = await imageRef4.getData();
    final imageBytes5 = await imageRef5.getData();
    final imageBytes6 = await imageRef6.getData();
    final imageBytes7 = await imageRef7.getData();

    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.SizedBox(height: 5),
          pw.Container(
            width: 100.0,
            height: 100.0,
            decoration: const pw.BoxDecoration(
              shape: pw.BoxShape.circle,
            ),
            child: pw.Image(pw.MemoryImage(logoBytes!)),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Loan Details',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            context: context,
            cellAlignment: pw.Alignment.centerLeft,
            headerAlignment: pw.Alignment.centerLeft,
            cellHeight: 30,
            headerHeight: 40,
            headers: ['Field', 'Value'],
            data: [
              ['User Name', loan.userName],
              ['Loan Type', loan.loanType],
              ['Phone', loan.phone],
              ['Pan Number', loan.panNoCpy],
              ['Aadhar Number', loan.aadharNo],
              ['Date', loan.date],
              ['Address', loan.address],
              ['PinCode', loan.pin],
              ['Email', loan.email],
              ['Income', loan.combinedIncome],
              
              ['PAN Image', pw.Container(
                width: 150.0,
                height: 150.0,
                decoration: const pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Image(pw.MemoryImage(panBytes!)),
              )],
              ['Aadhar Image', pw.Container(
                width: 150.0,
                height: 150.0,
                decoration: const pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Image(pw.MemoryImage(aadharBytes!)),
              )],

              ['User Image', 
                pw.Container(
            width: 80.0,
            height: 80.0,
            decoration: const pw.BoxDecoration(
              shape: pw.BoxShape.circle,
            ),
            child: pw.Image(pw.MemoryImage(imageBytes7!)),
          ),],


          ['Second Image', 
               pw.Container(
            width: 80.0,
            height: 80.0,
            decoration: const pw.BoxDecoration(
              shape: pw.BoxShape.circle,
            ),
            child: pw.Image(pw.MemoryImage(imageBytes4!)),
          ),],

          ['IT Return Image', 
                pw.Container(
            width: 80.0,
            height: 80.0,
            decoration: const pw.BoxDecoration(
              shape: pw.BoxShape.circle,
            ),
            child: pw.Image(pw.MemoryImage(imageBytes5!)),
          ),],


               ['Form16 Image', 
                 pw.Container(
            width: 80.0,
            height: 80.0,
            decoration: const pw.BoxDecoration(
              shape: pw.BoxShape.circle,
            ),
            child: pw.Image(pw.MemoryImage(imageBytes6!)),
          ),],


            ],
          ),
        ],
      ),
    ));

    final Uint8List pdfBytes = await pdf.save();
    final blob = html.Blob([pdfBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = 'loan_data.pdf'
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
