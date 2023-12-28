// loan_request_widget.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/loan_model/loan_model.dart';
import 'package:finkin_admin/widgets/loantrack/loan_track.dart';
import 'package:flutter/material.dart';

class AllLoans extends StatelessWidget {
  const AllLoans({super.key});

   @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('Loan').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const  Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 60.0,
        height: 60.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          value: 0.5,
        ),
      ),
      SizedBox(height: 10), 
      Text(
        'Loading', 
        style: TextStyle(color: Colors.black),
      ),
    ],
  ),
);

            
        }
        else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Loan found.'),
            );
          }

        List<LoanModel> loans = snapshot.data?.docs
            .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                LoanModel.fromSnapshot(doc))
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

