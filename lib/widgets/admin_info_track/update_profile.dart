import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../admin_dashboard/views/admin_view.dart';
import '../../controller/admin_controller/admin_controller.dart';
import '../../controller/admin_data_controller/adminData_controller.dart';
import '../../controller/auth_controller/auth_controller.dart';
import '../../repository/admin_repository.dart';

class UpdateInfo extends StatefulWidget {
  const UpdateInfo({Key? key}) : super(key: key);

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  final AdminDataController _adminDataController =
      Get.put(AdminDataController());
  final TextEditingController _nameController = TextEditingController();
  final AdminController controller = Get.put(AdminController());
  final AuthController authController = Get.put(AuthController());
  final adminrepo = Get.put(AdminRepository());
  Uint8List? _imageBytes;
  String? _imageUrl; // Change the type to String
  List<String?> _adminData = ["Default Name", null];
  Uint8List? _pickedImageBytes;
  @override
  void initState() {
    super.initState();
    _fetchAdminData();
    _nameController.text = _adminData[0]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                      color: ScreenColor.subtext.withOpacity(0.4),
                    ),
                    child: _pickedImageBytes != null
                        ? Image.memory(
                            _pickedImageBytes!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          )
                        : (_imageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: ScreenColor.textLight,
                              )
                            : ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: _imageUrl!,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: ScreenColor.textLight,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _nameController,
                  onChanged: (value) {
                    // Update the _adminData list when the user types
                    _adminData[0] = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _updateAdminData();

                  Get.off(() => const AdminView(
                        documentId: '',
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ScreenColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: ScreenColor.textLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchAdminData() async {
    try {
      String adminId = authController.adminId.value;
      List<String?> data = await _adminDataController.getAdminData(adminId);
      setState(() {
        _adminData = data;
        _imageUrl = data[1];
        _nameController.text = _adminData[0] ?? "";
      });
    } catch (e) {
      print('Error fetching admin data: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImagePickerWeb.getImageAsBytes();
      setState(() {
        _pickedImageBytes = pickedImage;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _updateAdminData() async {
    try {
      String adminId = authController.adminId.value;
      String adminName = _nameController.text;

      // Fetch the document with the specified admin ID
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Admin')
              .where('AdminId', isEqualTo: adminId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Document with the specified admin ID exists
        // Update admin name
        await adminrepo.updateAdminName(adminId, adminName);

        // Update admin image if available
        if (_pickedImageBytes != null) {
          // Upload image to Firebase Storage and get the download URL
          String imageUrl = await uploadImageToStorage(_pickedImageBytes!);
          await adminrepo.updateAdminImage(adminId, imageUrl);
        }

        Get.snackbar("Success", "Admin data updated successfully");
      } else {
        // Document with the specified admin ID does not exist
        Get.snackbar("Error", "Admin document not found");
      }
    } catch (e) {
      print('Error updating admin data: $e');
      Get.snackbar("Error", "Something went wrong. Try again");
    }
  }

  Future<String> uploadImageToStorage(Uint8List imageBytes) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('admin_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = ref.putData(imageBytes);

    String? imageUrl;
    await uploadTask.whenComplete(() async {
      imageUrl = await ref.getDownloadURL();
    }).catchError((onError) {
      print('Error uploading image: $onError');
    });

    return imageUrl!;
  }
}