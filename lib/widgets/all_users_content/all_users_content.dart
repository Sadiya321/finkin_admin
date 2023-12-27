import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/widgets/user_track/user_track.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Loan').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator( 
              semanticsLabel: 'Loading',
            backgroundColor: Colors.grey,
            value: 0.5,
            ); // Loading indicator while fetching data
          }

          List<User> users = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return User(data['UserName'], data['PanImg']);
          }).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserGridItem(user: users[index]);
            },
          );
        },
      ),
    );
  }
}