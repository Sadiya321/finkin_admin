import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:finkin_admin/login/views/login_view.dart';
import 'package:finkin_admin/repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyAjT-XeoSGtMgNI6mA_kTKEnlfMmHazn3U",
            appId: "1:518712046700:web:17a820bfa5dcea391fd449",
            storageBucket: "gs://finkin-credential.appspot.com",
            messagingSenderId: "518712046700",
            projectId: "finkin-credential",
          )
        : null,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final authController = AuthenticationRepository();
  @override
  Widget build(BuildContext context) {
    authController.onReady();
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        if (authController.firebaseAgent.value == null) {
          return const HomePage();
        } else {
          return const AdminView(documentId: '',);
        }
      }),
    );
  }
}
