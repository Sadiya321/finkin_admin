import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../controller/auth_controller/auth_controller.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final authController = Get.put(AuthController());

  final _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseAgent;

  get firebaseUser => null;

  @override
  void onReady() {
    firebaseAgent = Rx<User?>(_auth.currentUser);
    firebaseAgent.bindStream(_auth.userChanges());
    print('djgfhdf');

    ever(firebaseAgent, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    firebaseAgent.value = user;
    authController.isUserExist(user?.phoneNumber?.substring(3) ?? '123');
  }
}
