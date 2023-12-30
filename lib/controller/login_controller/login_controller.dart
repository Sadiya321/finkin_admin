import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthentication {
  final BuildContext context; // Add this line

  FirebaseAuthentication(this.context); // Add this constructor

  String phoneNumber = "";

  sendOTP(String phoneNumber) async {
    this.phoneNumber = phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(
      '+91 $phoneNumber',
    );
    printMessage("OTP Sent to +91 $phoneNumber");
    return confirmationResult;
  }

  authenticateMe(ConfirmationResult confirmationResult, String otp) async {
    try {
      UserCredential userCredential = await confirmationResult.confirm(otp);
      if (userCredential.additionalUserInfo!.isNewUser) {
        printMessage("Successful Authentication");

        // Navigate to the screen for successful authentication
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminView(documentId: '',),
          ),
        );
      } else {
        printMessage("User already exists");

        // Navigate to the screen for existing users
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminView(documentId: '',),
          ),
        );
      }
    } catch (e) {
      print("Authentication error: $e");
    }
  }

  printMessage(String msg) {
    debugPrint(msg);
  }
}
