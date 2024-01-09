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
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double imageSizePercentage = screenWidth < 600 ? 0.40 : 0.54;
        double fontSizePercentage = screenWidth < 600 ? 0.075 : 0.80;

        double imageSize = screenWidth * imageSizePercentage;
        double fontSize = screenWidth * fontSizePercentage;

        return GestureDetector(
          onTap: onPressed,
          child: Column(
            children: [
              Container(
                width: imageSize,
                height: imageSize,
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
                style: TextStyle(fontSize: fontSize),
              ),
            ],
          ),
        );
      },
    );
  }
}