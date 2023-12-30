import 'package:flutter/material.dart';

class User {
  final String username;
  final String userImage;
  final String email;
  final String phone;

  User(this.username, this.userImage, this.email, this.phone);
}

class UserGridItem extends StatelessWidget {
  final User user;
  final VoidCallback? onPressed;
  const UserGridItem(
      {super.key,
      required this.user,
      required String searchQuery,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed, // Execute the onPressed callback on tap
        child: Column(
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
            const SizedBox(height: 8.0),
            Text(
              user.username,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
