import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:finkin_admin/login/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAjT-XeoSGtMgNI6mA_kTKEnlfMmHazn3U",
    appId: "1:518712046700:web:17a820bfa5dcea391fd449",
    messagingSenderId: "518712046700",
    projectId: "finkin-credential",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      
      ),
      debugShowCheckedModeBanner: false,
      home: const AdminView(documentId: '',),
    );
  }
}
