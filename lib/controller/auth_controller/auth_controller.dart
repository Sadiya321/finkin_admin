import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString adminId = ''.obs;
  static AuthController get instance => Get.find();
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
}
