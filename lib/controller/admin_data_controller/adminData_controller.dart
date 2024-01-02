import 'package:finkin_admin/repository/admin_repository.dart';
import 'package:get/get.dart';

import '../../loan_model/admin_model.dart';

class AdminDataController extends GetxController {
  static AdminDataController get instance => Get.find();
  final AdminRepository adminRepository = Get.put(AdminRepository());

  Future<List<String?>> getAdminData(String adminId) async {
    try {
      String? agentName = await getAdminName(adminId);
      String? agentImage = await getAdminImage(adminId);
      return [agentName, agentImage];
    } catch (e) {
      print('Error fetching agent data: $e');
      return ["Default Name", null];
    }
  }

  Future<String?> getAdminImage(String adminId) async {
    try {
      print("Fetching agent image with ID: $adminId");
      final AdminModel? admin = await adminRepository.getAdminById(adminId);
      print("Fetched agent: $admin");
      return admin?.adminImage;
    } catch (e) {
      print('Error fetching agent image: $e');
      return null;
    }
  }

  Future<String?> getAdminName(String adminId) async {
    try {
      print("Fetching agent with ID: $adminId");
      final AdminModel? admin = await adminRepository.getAdminById(adminId);
      print("Fetched agent: $admin");
      return admin?.adminName;
    } catch (e) {
      print('Error fetching agent name: $e');
      return null;
    }
  }
}
