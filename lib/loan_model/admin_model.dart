import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String? id;
  final String adminId;
  final String adminImage;
  final String adminName;

  AdminModel({
    this.id,
    required this.adminId,
    required this.adminImage,
    required this.adminName,
  });

  toJson() {
    return {
      "AdminId": adminId,
      "AdminName": adminName,
      "AdminImage": adminImage,
    };
  }

  factory AdminModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return AdminModel(
      id: document.id,
      adminId: data?["AdminId"] ?? "",
      adminImage: data?["AdminImage"] ?? "",
      adminName: data?["AdminName"] ?? "",
    );
  }
}
