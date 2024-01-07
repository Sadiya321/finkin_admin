import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  RxString imageUrl = ''.obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  static const String nameRegex = r'^[A-Za-z\s]+$';

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      Get.snackbar('Success', 'Saving Details');

      return true;
    } else {
      Get.snackbar('Error', 'Please fix the errors in the form');
      return false;
    }
  }
}
