import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/loan_model/admin_model.dart';
import 'package:get/get.dart';

class AdminRepository extends GetxController {
  static AdminRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createAdmin(AdminModel admin) async {
    try {
      await _db.collection("Admin").add(admin.toJson());

      Get.snackbar("Success", "Your form has been recorded",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ScreenColor.icon.withOpacity(0.1),
          colorText: ScreenColor.icon);

      Get.to(const AdminView(
        documentId: '',
      ));
    } catch (error) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ScreenColor.icon.withOpacity(0.1),
          colorText: ScreenColor.icon);
    }
  }

  Future<AdminModel?> getAdminById(String adminId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('Admin')
          .where('AdminId', isEqualTo: adminId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> document =
            querySnapshot.docs.first;
        return AdminModel.fromSnapshot(document);
      } else {
        print("Document does not exist.");
        return null;
      }
    } catch (e) {
      print('Error fetching agent data: $e');
      return null;
    }
  }
}
