// loan_request_widget.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:finkin_admin/widgets/loantrack/loan_track.dart';
import 'package:flutter/material.dart';

class ApprovedLoans extends StatelessWidget {
  const ApprovedLoans({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('Loan').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            semanticsLabel: 'Loading',
            backgroundColor: Colors.grey,
             value: 0.5,
             );
        }

        List<LoanModel> loans = snapshot.data?.docs
            .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                LoanModel.fromSnapshot(doc))
            .where((loan) => loan.status == LoanStatus.approved) // Filter approved loans
            .toList() ?? [];

        return Center(
          child: ListView.builder(
            itemCount: loans.length,
            itemBuilder: (context, index) {
              return LoanTrack(
                imageAsset: loans[index].userImage,
                userName: loans[index].userName,
                loanType: loans[index].loanType,
                onPressed: () {
                  // Handle the onPressed event
                  // You may want to navigate to a detailed view or perform some action
                },
                date: loans[index].date,
                icon: loans[index].icon,
                status: loans[index].status,
              );
            },
          ),
        );
      },
    );
  }
}
