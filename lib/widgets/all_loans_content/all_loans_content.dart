import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/widgets/loantrack/loan_track.dart';
import 'package:flutter/material.dart';

import '../../loan_info_display/other_display.dart';

class AllLoans extends StatefulWidget {
  const AllLoans({Key? key}) : super(key: key);

  @override
  _AllLoansState createState() => _AllLoansState();
}

class _AllLoansState extends State<AllLoans> {
  late List<LoanModel> allLoans;
  late List<LoanModel> displayedLoans;
   bool isSearching = false;
  TextEditingController searchController = TextEditingController();

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
        title: Text(isSearching ? 'Search Results' : 'All Loans'),
        actions: [
          _buildSearchBar(),
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
              child: Text('No Loan found.'),
            );
          }

          allLoans = snapshot.data?.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                      LoanModel.fromSnapshot(doc))
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
              ? const Center(
                  child: Text(
                    'Search results not found',
                    style: TextStyle(fontSize: 23),
                  ),
                )
              : ListView.builder(
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
