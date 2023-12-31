import 'dart:html' as html;
import 'dart:typed_data' show Uint8List;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/api/pdf_api.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:finkin_admin/widgets/admin_info_track/update_profile.dart';
import 'package:finkin_admin/widgets/approved_loans_content/otherDisplayContent.dart';
import 'package:finkin_admin/widgets/loantrack/loan_approve_track.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

import '../../controller/admin_data_controller/adminData_controller.dart';
import '../../controller/auth_controller/auth_controller.dart';
import '../../loan_info_display/other_display.dart';

class ApprovedLoans extends StatefulWidget {
  const ApprovedLoans({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ApprovedLoansState createState() => _ApprovedLoansState();
}

class _ApprovedLoansState extends State<ApprovedLoans> {
  final AuthController authController = Get.put(AuthController());
  final AdminDataController adminDataController =
      Get.put(AdminDataController());
  late List<LoanModel> allLoans;
  bool isSearching = false;
  late List<LoanModel> displayedLoans;
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

    final bytes = await pdf.save();
    final blob = html.Blob([Uint8List.fromList(bytes)]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = '$documentId.pdf'
      ..click();

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
        title: Text(isSearching ? 'Search Results' : 'Approved Loans',
          style: MediaQuery.of(context).size.width < 600
        ? const TextStyle(fontSize: 18) // Adjust the font size for mobile view
        : const TextStyle(fontSize: 25), ),
        actions: [
          _buildSearchBar(),
          const SizedBox(
            width: 10,
          ),
          FutureBuilder<List<String?>>(
            future:
                adminDataController.getAdminData(authController.adminId.value),
            builder: (context, snapshot) {
              String agentName = snapshot.data?[0] ?? "";
              String? agentImage = snapshot.data?[1];

              return Row(
                children: [
                  
                  Text(agentName),
                  const SizedBox(
                    width: 10,
                  ),
                   InkWell(
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UpdateInfo(),
      ),
    );
  },
  child: CircleAvatar(
    radius: 20.0,
    backgroundColor: ScreenColor.subtext,
    backgroundImage: agentImage != null
        ? NetworkImage(agentImage)
        : const AssetImage('assets/images/error.png') as ImageProvider<Object>?,
  ),
),
                ],
              );
            },
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
            return Center(
              child: Text(
                isSearching
                    ? ' Approved Loans Not Found.'
                    : 'No Approved Loans for now',
                style: const TextStyle(fontSize: 23),
              ),
            );
          }

          allLoans = snapshot.data?.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                      LoanModel.fromSnapshot(doc))
                  .where((loan) => loan.status == LoanStatus.approved)
                  .toList() ??
              [];

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
              ? Center(
                  child: Text(
                  isSearching
                      ? 'Search results not found'
                      : ' Approved Loans Not found ',
                  style: const TextStyle(fontSize: 26),
                ))
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
                      onDownloadPressed: () async {
                        final documentId = displayedLoans[index].id;
                        if (documentId != null) {
                          await PdfApi.generatePdfForLoan(documentId);
                        }
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
     width: MediaQuery.of(context).size.width < 600 ? 120.0 : 200.0,
    
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
