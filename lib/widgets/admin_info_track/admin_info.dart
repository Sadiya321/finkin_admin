import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/controller/admin_controller/admin_controller.dart';
import 'package:finkin_admin/loan_model/admin_model.dart';
import 'package:finkin_admin/repository/admin_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminInfo extends StatefulWidget {
  const AdminInfo({Key? key}) : super(key: key);

  @override
  State<AdminInfo> createState() => _AdminInfoState();
}

class _AdminInfoState extends State<AdminInfo> {
  File? _selectedImage;
  bool isImageUploaded = false;
  final formKey = GlobalKey<FormState>();
  String imageValidationError = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final AdminController controller = Get.put(AdminController());
  final AdminController adminController = Get.find();
  final adminrepo = Get.put(AdminRepository());
  File? _image;
  Uint8List? _imageBytes; // Variable to store the selected image
  bool isButtonPressed = false;

  bool isFormValid() {
    // Check if form details are filled and image is fetched
    return formKey.currentState?.validate() ?? false && isImageUploaded;
  }

  final _db = FirebaseFirestore.instance;

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
                      prefixIcon: Icon(Icons.person),
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

      // Call uploadImageToFirebase to handle image upload
      bool isImageUploadSuccessful = await uploadImageToFirebase();

      // if (isImageUploadSuccessful) {
        const snackBar = SnackBar(
          content: Text(
            'Submitting Form',
            style: TextStyle(color: ScreenColor.textLight),
          ),
          backgroundColor: ScreenColor.primary,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Create Firestore collection named "Admin"
        final admin = AdminModel(
          adminId: controller.firstNameController.text.trim(),
          adminName: controller.firstNameController.text.trim(),
          adminImage: adminController.imageUrl.value,
        );

        await _db.collection("Admin").add(admin.toJson());
Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AdminView(documentId: '',)),
  );
        // Navigate to the desired screen after Firestore operation
        // Replace AdminView with your desired screen
      // } else {
      //   // Show an error message if image upload fails
      //   SnackBar snackBar = const SnackBar(
      //     content: Text(
      //       'Error uploading image. Please try again.',
      //       style: TextStyle(color: ScreenColor.textLight),
      //     ),
      //     backgroundColor: Colors.red,
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
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
)

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> uploadImageToFirebase() async {
    if (_image != null) {
      try {
        final firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('Admin_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        final firebase_storage.UploadTask uploadTask =
            storageRef.putFile(_image!);

        final firebase_storage.TaskSnapshot downloadSnapshot =
            await uploadTask.whenComplete(() => null);

        final String imageUrl = await downloadSnapshot.ref.getDownloadURL();

        setState(() {
          adminController.imageUrl.value = imageUrl;
          isImageUploaded = true;
          imageValidationError = '';
        });
        return true;
      } catch (e) {
        print('Error uploading image: $e');
        setState(() {
          imageValidationError = 'Error uploading image. Please try again.';
        });
        return false;
      }
    } else {
      setState(() {
        imageValidationError = 'Please select an image.';
      });
      return false; // Return false if no image is selected
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();

        setState(() {
          _image = File(pickedFile.path); // Update _image with the picked file
          _imageBytes = Uint8List.fromList(imageBytes);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      // Optionally, show a snackbar or dialog to inform the user about the error.
    }
  }
}
