import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String username;
  final String userImage;

  User(this.username, this.userImage);
}

class UserGridItem extends StatelessWidget {
  final User user;

  const UserGridItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90.0,
          height: 90.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2.0),
            image: DecorationImage(
              image: NetworkImage(user.userImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          user.username,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}


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
             );
          }

    List<User> users = snapshot.data!.docs.map((DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  String userName = data['UserName'];
  String userImage = data['PanImg'];
  print('User: $userName, Image: $userImage');
  return User(userName, userImage);
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
