import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/controller/admin_controller/admin_controller.dart';
import 'package:finkin_admin/controller/auth_controller/auth_controller.dart';
import 'package:finkin_admin/loan_model/admin_model.dart';
import 'package:finkin_admin/repository/admin_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AdminInfo extends StatefulWidget {
  const AdminInfo({Key? key}) : super(key: key);

  @override
  State<AdminInfo> createState() => _AdminInfoState();
}

class _AdminInfoState extends State<AdminInfo> {
  File? _image;
  final AuthController authController = Get.put(AuthController());
  Uint8List? _imageBytes;
  bool isImageUploaded = false;
  bool isButtonPressed = false;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final AdminController controller = Get.put(AdminController());
  final AdminController adminController = Get.find();
  final adminrepo = Get.put(AdminRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      child: _imageBytes == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            )
                          : ClipOval(
                              child: Image.memory(
                                _imageBytes!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200, // Adjust the width as needed
                  child: TextFormField(
                    controller: controller.firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (!isButtonPressed) {
                      isButtonPressed = true;
                      setState(() {});

                      bool isImageUploadSuccessful =
                          await uploadImageToFirebase();

                      if (isImageUploadSuccessful) {
                        const snackBar = SnackBar(
                          content: Text(
                            'Submitting Form',
                            style: TextStyle(color: ScreenColor.textLight),
                          ),
                          backgroundColor: ScreenColor.primary,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        final admin = AdminModel(
                          adminId: authController.adminId.value,
                          adminName: controller.firstNameController.text.trim(),
                          adminImage: adminController.imageUrl.value,
                        );

                        await FirebaseFirestore.instance
                            .collection("Admin")
                            .add(admin.toJson());

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminView(
                                    documentId: '',
                                  )),
                        );
                      } else {
                        const snackBar = SnackBar(
                          content: Text(
                            'Error uploading image. Please try again.',
                            style: TextStyle(color: ScreenColor.textLight),
                          ),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> uploadImageToFirebase() async {
    if (_imageBytes != null) {
      try {
        final firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('Admin/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Use putData() instead of putFile() for web
        final firebase_storage.UploadTask uploadTask =
            storageRef.putData(_imageBytes!);

        final firebase_storage.TaskSnapshot downloadSnapshot =
            await uploadTask; // Await the completion of the task

        if (downloadSnapshot.state == firebase_storage.TaskState.success) {
          final String imageUrl = await downloadSnapshot.ref.getDownloadURL();
          setState(() {
            adminController.imageUrl.value = imageUrl;
            isImageUploaded = true;
          });
          return true;
        } else {
          setState(() {
            isImageUploaded = false;
          });
          return false;
        }
      } catch (e) {
        print('Error uploading image: $e');
        setState(() {
          isImageUploaded = false;
        });
        return false;
      }
    } else {
      setState(() {
        isImageUploaded = false;
      });
      return false;
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePickerWeb.getImageAsBytes();

      if (pickedFile != null) {
        setState(() {
          _imageBytes = pickedFile; // Store the image bytes directly
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
