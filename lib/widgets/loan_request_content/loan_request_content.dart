import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:finkin_admin/widgets/loantrack/loan_track.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoanRequest extends StatelessWidget {
  const LoanRequest({Key? key});

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
            value: 0.5,
            semanticsLabel: 'Loading',
            backgroundColor: Colors.grey,
          );
        }

        List<LoanModel> loans = snapshot.data?.docs
                .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                    LoanModel.fromSnapshot(doc))
                .toList() ??
            [];
        List<LoanModel> pendingLoans =
            loans.where((loan) => loan.status == LoanStatus.pending).toList();

        return Center(
          child: ListView.builder(
            itemCount: pendingLoans.length,
            itemBuilder: (context, index) {
              return LoanTrack(
                imageAsset: pendingLoans[index].userImage,
                userName: pendingLoans[index].userName,
                loanType: pendingLoans[index].loanType,
                onPressed: () {},
                date: pendingLoans[index].date,
                icon: pendingLoans[index].icon,
                status: pendingLoans[index].status,
              );
            },
          ),
        );
      },
    );
  }
}
