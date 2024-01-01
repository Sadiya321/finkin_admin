// import 'dart:html';

import 'dart:html' as html;
import 'dart:typed_data' show Uint8List;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:finkin_admin/widgets/approved_loans_content/OtherDisplayContent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

import '../../loan_info_display/other_display.dart';
import '../loantrack/Loan_approve_track.dart';

class ApprovedLoans extends StatefulWidget {
  const ApprovedLoans({Key? key}) : super(key: key);

  @override
  _ApprovedLoansState createState() => _ApprovedLoansState();
}

class _ApprovedLoansState extends State<ApprovedLoans> {
  late List<LoanModel> allLoans;
  late List<LoanModel> displayedLoans;
  Future<void> _generateAndSavePDF(
    String documentId,
    String userName,
    String loanType,
    String panNo,
    String pin,
    String email,
    String phone,
    String aadharNo,
    String nationality,
    String address,
    String empType,
    String income,
    DateTime dob,
    // String imageUrl,
  ) async {
    final pdf = pw.Document();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dob);
    dob = DateTime.parse(formattedDate);
    // final Uint8List imageBytes = await _fetchImage(imageUrl);
    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Embed the image in the PDF
              // pw.Image(pw.MemoryImage(imageBytes)),
              // Other content from OtherDisplayContent widget
              OtherDisplayContent(
                documentId: documentId,
                userName: userName,
                loanType: loanType,
                panNo: panNo,
                pin: pin,
                email: email,
                phone: phone,
                aadarNo: aadharNo,
                nationality: nationality,
                address: address,
                empType: empType,
                income: income,
                dob: dob,
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF
    final bytes = await pdf.save();
    final blob = html.Blob([Uint8List.fromList(bytes)]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Trigger a download
    html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = '$documentId.pdf'
      ..click();

    // Clean up
    html.Url.revokeObjectUrl(url);
  }

  // Future<Uint8List> _fetchImage(String imageUrl) async {
  //   try {
  //     if (imageUrl.isEmpty) {
  //       print('Image URL is empty.');
  //       // Return a default image or handle the error as needed
  //       return Uint8List(0); // Return an empty Uint8List as a placeholder
  //     }
  //
  //     final response = await http.get(Uri.parse(imageUrl));
  //     if (response.statusCode == 200) {
  //       final Uint8List imageBytes = response.bodyBytes;
  //       // Check if the image data is not empty
  //       if (imageBytes.isEmpty) {
  //         print('Image data is empty.');
  //         // Return a default image or handle the error as needed
  //         return Uint8List(0); // Return an empty Uint8List as a placeholder
  //       }
  //       return imageBytes;
  //     } else {
  //       print('Failed to load image: ${response.statusCode}');
  //       // Return a default image or handle the error as needed
  //       return Uint8List(0); // Return an empty Uint8List as a placeholder
  //     }
  //   } catch (e) {
  //     print('Error loading image: $e');
  //     // Return a default image or handle the error as needed
  //     return Uint8List(0); // Return an empty Uint8List as a placeholder
  //   }
  // }

  @override
  void initState() {
    super.initState();
    allLoans = [];
    displayedLoans = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approved Loans'),
        actions: [
          Container(
            width: 250.0,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        displayedLoans = allLoans
                            .where((loan) =>
                                loan.userName
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                loan.loanType
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // You can add additional search functionality here if needed
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Loan').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Approved Loans found.'),
            );
          }

          allLoans = snapshot.data?.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                      LoanModel.fromSnapshot(doc))
                  .where((loan) => loan.status == LoanStatus.approved)
                  .toList() ??
              [];

          // Initially, set displayedLoans to allLoans
          if (displayedLoans.isEmpty) {
            displayedLoans = List.from(allLoans);
          }

          return ListView.builder(
            itemCount: displayedLoans.length,
            itemBuilder: (context, index) {
              final documentId = displayedLoans[index].id;
              return LoanAppTrack(
                imageAsset: displayedLoans[index].userImage,
                userName: displayedLoans[index].userName,
                loanType: displayedLoans[index].loanType,
                pin: displayedLoans[index].pin,
                email: displayedLoans[index].email,
                panNo: displayedLoans[index].panNo,
                phone: displayedLoans[index].phone,
                aadharNo: displayedLoans[index].aadharNo,
                nationality: displayedLoans[index].nationality,
                address: displayedLoans[index].address,
                empType: displayedLoans[index].empType,
                income: displayedLoans[index].combinedIncome,
                dob: displayedLoans[index].date,
                downloadIcon: Icons.download,
                onDownloadPressed: () {
                  _generateAndSavePDF(
                    documentId!,
                    displayedLoans[index].userName,
                    displayedLoans[index].loanType,
                    displayedLoans[index].panNo,
                    displayedLoans[index].pin,
                    displayedLoans[index].email,
                    displayedLoans[index].phone,
                    displayedLoans[index].aadharNo,
                    displayedLoans[index].nationality,
                    displayedLoans[index].address,
                    displayedLoans[index].empType,
                    displayedLoans[index].combinedIncome,
                    displayedLoans[index].date,
                    // displayedLoans[index].panImg,
                  );
                },
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OtherDisplay(
                        documentId: documentId!,
                      ),
                    ),
                  );
                  // Handle the onPressed event
                  // You may want to navigate to a detailed view or perform some action
                },
                date: displayedLoans[index].date,
                icon: displayedLoans[index].icon,
                status: displayedLoans[index].status,
              );
            },
          );
        },
      ),
    );
  }
}
