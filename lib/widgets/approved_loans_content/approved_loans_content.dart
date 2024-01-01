import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:finkin_admin/widgets/approved_loans_content/otherDisplayContent.dart';
import 'package:finkin_admin/widgets/loantrack/loan_approve_track.dart';
import 'package:finkin_admin/widgets/loantrack/loan_track.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'dart:typed_data' show Uint8List;
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import '../../loan_info_display/other_display.dart';

class ApprovedLoans extends StatefulWidget {
  const ApprovedLoans({Key? key}) : super(key: key);

  @override
  _ApprovedLoansState createState() => _ApprovedLoansState();
}

class _ApprovedLoansState extends State<ApprovedLoans> {
  late List<LoanModel> allLoans;
  late List<LoanModel> displayedLoans;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
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
        title: Text(isSearching ? 'Search Results' : 'Approved Loans'),
        actions: [
          _buildSearchBar(),
           const SizedBox(width: 20,),
            const Text("User Name Here"),
          const SizedBox(width: 20,),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey, ),
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
              return _buildLoadingIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(' Approved Loans Not Found.'),
            );
          }

          allLoans = snapshot.data?.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                      LoanModel.fromSnapshot(doc))
                  .where((loan) => loan.status == LoanStatus.approved)
                  .toList() ??
              [];

          // Update displayedLoans based on the search criteria
          displayedLoans = allLoans
              .where((loan) =>
                  loan.userName
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  loan.loanType
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
              .toList();

          return displayedLoans.isEmpty
              ? const Center(child: Text('search results Not Found.',style: TextStyle(fontSize: 26),))
              : ListView.builder(
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

   Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: CircularProgressIndicator(
              backgroundColor: ScreenColor.textdivider,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Loading',
            style: TextStyle(color: ScreenColor.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 200.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
         color: ScreenColor.subtext,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    isSearching = value.isNotEmpty;
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
