import 'package:finkin_admin/admin_dashboard/views/admin_view.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  bool isVerifyingOTP = false;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
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
                              child: TextFormField(
                                controller: phoneNumberController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Please enter a phone number';
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 12),
                                  prefixIcon: const Icon(Icons.phone),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: InputDecoration(
                              labelText: 'OTP',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              prefixIcon: const Icon(Icons.keyboard),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ScreenColor.primary),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (!isVerifyingOTP) {
                                String phoneNumber = phoneNumberController.text;
                                String otp = otpController.text;
                                print('Formatted Phone Number: $phoneNumber');
                                print('Entered OTP: $otp');

                                setState(() {
                                  isVerifyingOTP = true;
                                });
                              } else {
                                String otp = otpController.text;
                                print('Entered OTP: $otp');
                                setState(() {
                                  isVerifyingOTP = false;
                                });

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AdminView(),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            isVerifyingOTP ? 'Verify OTP' : 'Generate OTP',
                            style:
                                const TextStyle(color: ScreenColor.secondary),
                          ),
                        ),
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
                padding: const EdgeInsets.all(200.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Welcome',
                      style:
                          TextStyle(fontSize: 25, color: ScreenColor.textLight),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Unlock a world of data-driven insights, instant updates, and streamlined loan management. Securely log in to embark on a seamless journey toward mastering the art of lending.',
                      style:
                          TextStyle(fontSize: 18, color: ScreenColor.secondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
