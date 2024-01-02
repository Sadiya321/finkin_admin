import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:finkin_admin/widgets/loantrack/loan_track.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_data_controller/adminData_controller.dart';
import '../../loan_info_display/info_display.dart';

class LoanRequest extends StatefulWidget {
  const LoanRequest({Key? key}) : super(key: key);

  @override
  _LoanRequestState createState() => _LoanRequestState();
}

class _LoanRequestState extends State<LoanRequest> {
  final AdminDataController adminDataController =
      Get.put(AdminDataController());
  late List<LoanModel> allLoans;
  late List<LoanModel> displayedLoans;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  int get loanRequestsCount {
    return allLoans.where((loan) => loan.status == LoanStatus.pending).length;
  }

  int getDisplayedLoansCount() {
    // Replace this logic with your actual logic to count displayed loans
    return displayedLoans
        .length; // Assuming displayedLoans contains the requested loans
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
        title: Text(isSearching ? 'Search Results' : 'Loan Requests'),
        actions: [
          _buildSearchBar(),
          const SizedBox(
            width: 20,
          ),
          FutureBuilder<List<String?>>(
            future: adminDataController
                .getAdminData('wJkiOkXpwHh3osxsrXyVQ2UIUm33'),
            builder: (context, snapshot) {
              String agentName = snapshot.data?[0] ?? "";
              String? agentImage = snapshot.data?[1];

              return Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(agentName),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: agentImage != null
                          ? NetworkImage(agentImage) as ImageProvider<Object>?
                          : AssetImage('path_to_default_image')
                              as ImageProvider<Object>?,
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
                    ? 'Search results not found'
                    : 'No Loan Requests for now',
                style: TextStyle(fontSize: 23),
              ),
            );
          }

          allLoans = snapshot.data?.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                      LoanModel.fromSnapshot(doc))
                  .where((loan) => loan.status == LoanStatus.pending)
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

          if (displayedLoans.isEmpty) {
            return Center(
              child: Text(
                isSearching
                    ? 'Search results not found'
                    : 'No Loan Requests for now',
                style: TextStyle(fontSize: 23),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: displayedLoans.length,
              itemBuilder: (context, index) {
                final documentId = displayedLoans[index].id;
                return LoanTrack(
                  imageAsset: displayedLoans[index].userImage,
                  userName: displayedLoans[index].userName,
                  loanType: displayedLoans[index].loanType,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InfoDisplay(
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
          }
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
