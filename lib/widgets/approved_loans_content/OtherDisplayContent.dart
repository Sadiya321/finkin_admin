import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OtherDisplayContent extends pw.StatelessWidget {
  final String documentId;
  final String userName;
  final String loanType;
  final String phone;
  final String email;
  final String pin;
  final String panNo;
  final String aadarNo;
  final String nationality;
  final String address;
  final String empType;
  final String income;
  // final String imageUrl;

  final DateTime dob;

  OtherDisplayContent({
    Key? key,
    required this.documentId,
    required this.userName,
    required this.loanType,
    required this.panNo,
    required this.email,
    required this.pin,
    required this.phone,
    required this.aadarNo,
    required this.nationality,
    required this.address,
    required this.empType,
    required this.income,
    required this.dob,
    // required this.imageUrl,
  });

  @override
  pw.Widget build(pw.Context context) {
    final formattedDOB =
        '${dob.day}/${dob.month}/${dob.year}'; // Adjust the format as needed

    return pw.Container(
      padding: const pw.EdgeInsets.all(20.0),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 2.0),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10.0)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: _buildHeader('Bank Loan Application Form'),
          ),
          pw.Center(
            child: _buildHeader(loanType),
          ),
          pw.Center(
            child: _buildHeader(
                '------------------------------------------------------------'),
          ),
          // pw.SizedBox(height: 20.0),
          // _buildRow('Document ID:', documentId),
          pw.SizedBox(height: 10.0),
          _buildRow('Name:', userName),
          pw.SizedBox(height: 10.0),
          _buildRow('DOB:', formattedDOB),
          pw.SizedBox(height: 10.0),
          _buildRow('Phone NO:', phone),
          pw.SizedBox(height: 10.0),
          _buildRow('Nationality:', nationality),
          pw.SizedBox(height: 10.0),
          _buildRow('Pan NO:', panNo),
          pw.SizedBox(height: 10.0),
          _buildRow('Aadhar No:', aadarNo),
          pw.SizedBox(height: 10.0),
          _buildRow('Pin Code:', pin),
          pw.SizedBox(height: 10.0),
          _buildRow('Email:', email),
          pw.SizedBox(height: 10.0),
          _buildRow('Address:', address),
          pw.SizedBox(height: 10.0),
          _buildRow('Employment Type:', empType),
          pw.SizedBox(height: 10.0),
          _buildRow('Income:', income),

          // Add more content here based on your needs
        ],
      ),
    );
  }

  pw.Widget _buildHeader(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 18.0,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue,
      ),
    );
  }

  pw.Widget _buildRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 14.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(width: 20.0),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14.0),
          ),
        ),
      ],
    );
  }
}
