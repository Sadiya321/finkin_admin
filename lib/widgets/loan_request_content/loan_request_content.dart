import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:finkin_admin/loan_info_display/info_display.dart';
import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/widgets/loantrack/loan_track.dart';
import 'package:flutter/material.dart';

class LoanRequest extends StatefulWidget {
  const LoanRequest({Key? key});

  @override
  _LoanRequestState createState() => _LoanRequestState();
}

class _LoanRequestState extends State<LoanRequest> {
  late List<LoanModel> allLoans;
  late List<LoanModel> displayedLoans;

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
        title: const Text('Loan Requests'),
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
              child: Text('No Loan Requests found.'),
            );
          }

          allLoans = snapshot.data?.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                      LoanModel.fromSnapshot(doc))
                  .toList() ??
              [];
          if (displayedLoans.isEmpty) {
            displayedLoans = List.from(allLoans);
          }
          final data = snapshot.requireData;
            List<LoanModel> loanItems = snapshot.data!.docs
                .map((DocumentSnapshot doc) => LoanModel.fromSnapshot(
                    doc as DocumentSnapshot<Map<String, dynamic>>))
                .toList();

          return ListView.builder(
            itemCount: displayedLoans.length,
            itemBuilder: (context, index) {
              final documentId = data.docs[index].id;
              return LoanTrack(
                imageAsset: displayedLoans[index].userImage,
                userName: displayedLoans[index].userName,
                loanType: displayedLoans[index].loanType,
                onPressed: () {
 
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => InfoDisplay( documentId:documentId,)),
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
}
