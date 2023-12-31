import 'dart:io';
import 'dart:typed_data';
import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminInfo extends StatefulWidget {
  const AdminInfo({Key? key}) : super(key: key);

  @override
  State<AdminInfo> createState() => _AdminInfoState();
}

class _AdminInfoState extends State<AdminInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  Uint8List? _imageBytes; // Variable to store the selected image

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
                    controller: _nameController,
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
                  onPressed:
                   () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an image.'),
                          ),
                        );
                        return;
                      }
                      // Form is valid, save the admin's name and image
                      String adminName = _nameController.text;
                      // You can add more logic here, e.g., save to database, update state, etc.
                      print('Admin Name: $adminName');
                      print('Image Path: ${_image?.path}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Admin Name Saved: $adminName'),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminView(
                            documentId: '',
                          ), // Replace AdminView with your actual screen
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.deepPurple, // Set your preferred button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white), // Set text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
