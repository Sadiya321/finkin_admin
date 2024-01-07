import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/controller/login_controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth_controller/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool canShowOTPField = false;
  late FirebaseAuthentication _firebaseAuth;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _leftFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _rightFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _firebaseAuth = FirebaseAuthentication(context);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth < 600;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: isMobileView
                  ? MediaQuery.of(context).size.width // Center in mobile view
                  : MediaQuery.of(context).size.width / 3,
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                     key: _leftFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FadeTransition(
                          opacity: _fadeInAnimation,
                          child: Image.asset(
                            'assets/images/hill.png',
                            width: 250,
                            height: 350,
                          ),
                        ),
                        const Text(
                          'Admin Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: buildTextField("Phone Number",
                                  phoneNumberController, Icons.phone, 10),
                            ),
                          ],
                        ),
                        if (canShowOTPField)
                          buildTextField("OTP", otpController, Icons.timer, 6),
                        !canShowOTPField
                            ? buildSendOTPBtn("Send OTP")
                            : buildSubmitBtn("Submit"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: double.infinity,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color: ScreenColor.primary,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      ' Welcome',
                      style:
                          TextStyle(fontSize: 25, color: ScreenColor.textLight),
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double maxTextWidth =
                            constraints.maxWidth - 10.0; // Adjust for padding
                        double fontSize = 18.0;
                        if (maxTextWidth < 400) {
                          fontSize = 14.0;
                        } else if (maxTextWidth < 600) {
                          fontSize = 17.0;
                        }

                        return Center(
                          child: Text(
                            'Unlock a world of data-driven insights, instant updates, and streamlined loan management. Securely log in to embark on a seamless journey toward mastering the art of lending.',
                            style: TextStyle(
                                fontSize: fontSize,
                                color: ScreenColor.secondary),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: isMobileView
                    ? MediaQuery.of(context).size.width 
                    : MediaQuery.of(context).size.width / 3,
                child: Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                     key: _rightFormKey, 
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FadeTransition(
                            opacity: _fadeInAnimation,
                            child: Image.asset(
                              'assets/images/hill.png',
                              width: 250,
                              height: 350,
                            ),
                          ),
                          const Text(
                            'Admin Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField("Phone Number",
                                    phoneNumberController, Icons.phone, 10),
                              ),
                            ],
                          ),
                          if (canShowOTPField)
                            buildTextField(
                                "OTP", otpController, Icons.timer, 6),
                          !canShowOTPField
                              ? buildSendOTPBtn("Send OTP")
                              : buildSubmitBtn("Submit"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      IconData icon, int maxLength) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
        ),
      ),
    );
  }

  Widget buildSendOTPBtn(String text) => ElevatedButton(
        onPressed: () async {
          try {
            setState(() {
              canShowOTPField = !canShowOTPField;
            });
          } catch (e) {
            print("Error sending OTP: $e");
          }
        },
        child: Text(text),
      );

  Widget buildSubmitBtn(String text) => ElevatedButton(
        onPressed: () async {
          try {
            var confirmationResult =
                await _firebaseAuth.sendOTP(phoneNumberController.text);
            await _firebaseAuth.authenticateMe(
                confirmationResult, otpController.text);
          } catch (e) {
            print("Error authenticating: $e");
          }
        },
        child: Text(text),
      );
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width, size.height - 90);
    path.quadraticBezierTo(
        size.width - 10, size.height - 60, size.width - 20, size.height - 50);
    path.quadraticBezierTo(
        size.width - 30, size.height - 40, size.width - 40, size.height - 50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Future<bool> isFirstLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;
  return isFirstLogin;
}

Future<void> markLoginNotFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstLogin', false);
}
