import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/loan_model/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString adminId = ''.obs;
  static AuthController get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  AuthController() {
    initAuthListener();
  }
  void initAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        adminId.value = user.uid;
      } else {
        adminId.value = '';
      }
    });
  }

  Future<bool> isUserExist(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('AdminNumberCollection')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print("Error checking user existence: $error");
      return false;
    }
  }

  Future<void> storeAgentIdInFirestore(String adminId) async {
    try {
      String? uid = _auth.currentUser?.uid;

      if (uid != null) {
        CollectionReference agentsCollection =
            FirebaseFirestore.instance.collection('Admin');

        await agentsCollection.doc(uid).set({
          'AdminId': adminId,
        });
      }
    } catch (e) {
      print("Error storing adminId in Firestore: $e");
    }
  }
  Future<AdminModel?> getAgentById(String adminId) async {
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
