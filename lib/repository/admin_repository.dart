import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/loan_model/admin_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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

      // Navigate to the desired screen after success
      Get.to(AdminView(documentId: '',)); // Replace NextScreen with your desired screen
    } catch (error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ScreenColor.icon.withOpacity(0.1),
          colorText: ScreenColor.icon);
    }
  }
}
