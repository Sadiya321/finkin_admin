import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/controller/user_info_controller/info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_stepper_flutter/horizontal_stepper_flutter.dart';

class InfoDisplay extends StatefulWidget {
  final String documentId;

  const InfoDisplay({Key? key, required this.documentId}) : super(key: key);

  @override
  State<InfoDisplay> createState() => _InfoDisplayState();
}

class _InfoDisplayState extends State<InfoDisplay> {
  static final GlobalKey<_InfoDisplayState> globalKey =
      GlobalKey<_InfoDisplayState>();
  bool isPersonalDetailsSelected = true;
  final UserInfoController userInfoController = Get.put(UserInfoController());
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    userInfoController.fetchUserDetails(widget.documentId);
  }

  ImageProvider _buildImageProvider(String imageUrl) {
    try {
      return NetworkImage(imageUrl);
    } catch (e) {
      print("Error loading image: $e");
      return const AssetImage('assets/images/contact.svg');
    }
  }

  void refresh() {
    setState(() {});
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  imageUrl,
                  height: 420,
                  width: 500,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ScreenColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: ScreenColor.textLight),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile View
              return buildMobileUI();
            } else {
              // Desktop View
              return buildDesktopUI(constraints);
            }
          },
        ),
      ),
    );
  }

  Widget buildDesktopUI(BoxConstraints constraints) {
    return Obx(() {
      if (userInfoController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: ScreenColor.primary,
          ),
        );
      } else {
        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              title:
                  Text('Loan', style: TextStyle(color: ScreenColor.textLight)),
              backgroundColor: ScreenColor.primary,
              centerTitle: true,
              automaticallyImplyLeading: false,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: constraints.maxWidth * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _showImageDialog(
                                    userInfoController.userImage.value);
                              },
                              child: CircleAvatar(
                                backgroundImage: _buildImageProvider(
                                    userInfoController.userImage.value),
                                radius: 50,
                                backgroundColor: ScreenColor.secondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              userInfoController.fullName.value,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "USER-${userInfoController.userid.value}",
                              style: const TextStyle(
                                color: ScreenColor.textdivider,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // pinpom
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: constraints.maxWidth * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              height: 180,
                              width: 500,
                              decoration: BoxDecoration(
                                color: ScreenColor.textLight,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: ScreenColor.textPrimary,
                                  width: 0.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ScreenColor.textdivider
                                        .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      userInfoController.currentStep.value == 5
                                          ? "Loan Denied"
                                          : "Loan Status",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: ScreenColor.primary,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: FlutterHorizontalStepper(
                                      completeStepColor: userInfoController
                                                  .currentStep.value ==
                                              5
                                          ? ScreenColor.errorbar
                                          : ScreenColor.icon,
                                      titleStyle: const TextStyle(
                                        color: ScreenColor.primary,
                                        fontSize: 12,
                                      ),
                                      steps: const [
                                        "Application sent",
                                        "Approval Pending",
                                        "Loan Approved",
                                        "Loan Denied"
                                      ],
                                      radius: 45,
                                      currentStep:
                                          userInfoController.currentStep.value,
                                      currentStepColor: ScreenColor.secondary,
                                      child: const [
                                        Icon(Icons.bookmark_add_sharp),
                                        Icon(Icons.hourglass_top_sharp),
                                        Icon(Icons.check_rounded, size: 32),
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: ScreenColor.errorbar,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _approveLoan(widget.documentId);
                                    // Check if this prints

                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    fixedSize: const Size(150, 40),
                                    backgroundColor: ScreenColor.icon,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Approve Loan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ScreenColor.textLight,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _denyLoan(widget.documentId);
                                  },
                                  style: TextButton.styleFrom(
                                    fixedSize: const Size(150, 40),
                                    backgroundColor: ScreenColor.errorbar,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel Loan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ScreenColor.textLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isPersonalDetailsSelected = true;
                          });
                        },
                        style: TextButton.styleFrom(
                          fixedSize: const Size(550, 50),
                          backgroundColor: isPersonalDetailsSelected
                              ? ScreenColor.primary
                              : ScreenColor.subtext,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text(
                          'Personal Details',
                          style: TextStyle(
                            fontSize: 12,
                            color: ScreenColor.textLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 0.0),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isPersonalDetailsSelected = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          fixedSize: const Size(550, 50),
                          backgroundColor: isPersonalDetailsSelected
                              ? ScreenColor.subtext
                              : ScreenColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text(
                          'Other Details',
                          style: TextStyle(
                            fontSize: 12,
                            color: ScreenColor.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: ScreenColor.textLight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: isPersonalDetailsSelected
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LabeledTextField2(
                                label: 'Full Name',
                                hintText: userInfoController.fullName.value,
                              ),
                              const SizedBox(height: 10),
                              LabeledTextField2(
                                label: 'Email',
                                hintText: userInfoController.email.value,
                              ),
                              const SizedBox(height: 10),
                              LabeledTextField2(
                                label: 'Phone ',
                                hintText: userInfoController.phone.value,
                              ),
                              const SizedBox(height: 10),
                              LabeledTextField2(
                                label: 'Date Of Birth ',
                                hintText: userInfoController.dob.value,
                              ),
                              const SizedBox(height: 10),
                              LabeledTextField2(
                                label: 'Address',
                                hintText: userInfoController.address.value,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              LabeledTextField2(
                                label: 'Pincode',
                                hintText: userInfoController.pin.value,
                              ),
                              const SizedBox(height: 10),
                              LabeledTextField2(
                                label: 'Nationality :',
                                hintText: userInfoController.nation.value,
                              ),
                              const SizedBox(height: 10),
                              LabeledTextField2(
                                label: 'Aadhar Card Number ',
                                hintText: userInfoController.aadharNo.value,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Aadhar Card Photo',
                                    style: TextStyle(
                                      color: ScreenColor.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 470,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showImageDialog(
                                          userInfoController.aadharImg.value);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(90, 46),
                                      backgroundColor: ScreenColor.primary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Image',
                                      style: TextStyle(
                                          color: ScreenColor.textLight),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              LabeledTextField2(
                                label: 'Pan Card Number',
                                hintText: userInfoController.panNo.value,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Pan Card Photo',
                                    style: TextStyle(
                                      color: ScreenColor.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 500,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showImageDialog(
                                          userInfoController.panImg.value);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(90, 46),
                                      backgroundColor: ScreenColor.primary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Image',
                                      style: TextStyle(
                                          color: ScreenColor.textLight),
                                    ),
                                  ),
                                ],
                              ),
                              LabeledTextField2(
                                label: 'Employee Type',
                                hintText: userInfoController.empType.value,
                              ),
                              const SizedBox(height: 10),
                              LabeledTextField2(
                                label: 'Monthly Income ',
                                hintText: userInfoController.mincome.value,
                              ),
                              Text(
                                userInfoController.empType.value ==
                                        'Company Worker'
                                    ? 'Form 16 and Bank Statement'
                                    : 'IT Return of Two Years',
                                style: const TextStyle(
                                  color: ScreenColor.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userInfoController.empType.value ==
                                            'Company Worker'
                                        ? 'Form 16'
                                        : 'First Year',
                                    style: const TextStyle(
                                      color: ScreenColor.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 540,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showImageDialog(
                                          userInfoController.itReturnImg.value);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(90, 46),
                                      backgroundColor: ScreenColor.primary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Image',
                                      style: TextStyle(
                                          color: ScreenColor.textLight),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userInfoController.empType.value ==
                                            'Company Worker'
                                        ? 'Bank Statement'
                                        : 'Second Year',
                                    style: const TextStyle(
                                      color: ScreenColor.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 520,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showImageDialog(
                                          userInfoController.secondImg.value);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(90, 46),
                                      primary: ScreenColor.primary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Image',
                                      style: TextStyle(
                                          color: ScreenColor.textLight),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    });
  }

  Widget buildMobileUI() {
    return Obx(() {
      if (userInfoController.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(
          color: ScreenColor.primary,
        ));
      } else {
        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              title:
                  Text('Loan', style: TextStyle(color: ScreenColor.textLight)),
              backgroundColor: ScreenColor.primary,
              centerTitle: true,
              automaticallyImplyLeading: false,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: ScreenColor.textLight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                  backgroundImage: _buildImageProvider(
                                      userInfoController.userImage.value),
                                  radius: 50,
                                  backgroundColor: ScreenColor.secondary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userInfoController.fullName.value,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "USER-${userInfoController.userid.value}",
                                style: const TextStyle(
                                  color: ScreenColor.textdivider,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(20),
                                height: 180,
                                width: 345,
                                decoration: BoxDecoration(
                                  color: ScreenColor.textLight,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: ScreenColor.textPrimary,
                                    width: 0.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ScreenColor.textdivider
                                          .withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        userInfoController.currentStep.value ==
                                                5
                                            ? "Loan Denied"
                                            : "Loan Status",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: ScreenColor.primary,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: FlutterHorizontalStepper(
                                        completeStepColor: userInfoController
                                                    .currentStep.value ==
                                                5
                                            ? ScreenColor.errorbar
                                            : ScreenColor.icon,
                                        titleStyle: const TextStyle(
                                            color: ScreenColor.primary,
                                            fontSize: 12),
                                        steps: const [
                                          "Application sent",
                                          "Approval Pending",
                                          "Loan Approved",
                                          "Loan Denied"
                                        ],
                                        radius: 45,
                                        currentStep: userInfoController
                                            .currentStep.value,
                                        currentStepColor: ScreenColor.secondary,
                                        child: const [
                                          Icon(Icons.bookmark_add_sharp),
                                          Icon(Icons.hourglass_top_sharp),
                                          Icon(Icons.check_rounded, size: 32),
                                          Icon(
                                            Icons.cancel_outlined,
                                            color: ScreenColor.errorbar,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _approveLoan(widget.documentId);

                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      fixedSize: const Size(150, 40),
                                      backgroundColor: ScreenColor
                                          .icon, // Use the appropriate color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Set the desired border radius
                                      ),
                                    ),
                                    child: const Text(
                                      'Approve Loan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ScreenColor.textLight,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  TextButton(
                                    onPressed: () {
                                      // Handle Cancel Loan button click
                                      _denyLoan(widget.documentId);
                                    },
                                    style: TextButton.styleFrom(
                                      fixedSize: const Size(150, 40),
                                      backgroundColor: ScreenColor
                                          .errorbar, // Use the appropriate color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Set the desired border radius
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel Loan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ScreenColor.textLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isPersonalDetailsSelected = true;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      fixedSize: const Size(140, 60),
                                      backgroundColor: isPersonalDetailsSelected
                                          ? ScreenColor.primary
                                          : ScreenColor.subtext,
                                    ),
                                    child: const Text(
                                      'Personal Details',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ScreenColor.textLight),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isPersonalDetailsSelected = false;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      fixedSize: const Size(140, 60),
                                      backgroundColor: isPersonalDetailsSelected
                                          ? ScreenColor.subtext
                                          : ScreenColor.primary,
                                    ),
                                    child: const Text(
                                      'Other Details',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ScreenColor.textLight),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          color: ScreenColor.textLight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: isPersonalDetailsSelected
                              ? Column(
                                  children: [
                                    LabeledTextField2(
                                      label: 'Full Name',
                                      hintText:
                                          userInfoController.fullName.value,
                                    ),
                                    const SizedBox(height: 10),
                                    LabeledTextField2(
                                      label: 'Email',
                                      hintText: userInfoController.email.value,
                                    ),
                                    const SizedBox(height: 10),
                                    LabeledTextField2(
                                      label: 'Phone ',
                                      hintText: userInfoController.phone.value,
                                    ),
                                    const SizedBox(height: 10),
                                    LabeledTextField2(
                                      label: 'Date Of Birth ',
                                      hintText: userInfoController.dob.value,
                                    ),
                                    const SizedBox(height: 10),
                                    LabeledTextField2(
                                      label: 'Address',
                                      hintText:
                                          userInfoController.address.value,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    LabeledTextField2(
                                      label: 'Pincode',
                                      hintText: userInfoController.pin.value,
                                    ),
                                    const SizedBox(height: 10),
                                    LabeledTextField2(
                                      label: 'Nationality :',
                                      hintText: userInfoController.nation.value,
                                    ),
                                    const SizedBox(height: 10),
                                    LabeledTextField2(
                                      label: 'Aadhar Card Number ',
                                      hintText:
                                          userInfoController.aadharNo.value,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Aadhar Card Photo',
                                          style: TextStyle(
                                            color: ScreenColor.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _showImageDialog(userInfoController
                                                .aadharImg.value);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(90, 46),
                                            backgroundColor:
                                                ScreenColor.primary,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'View Image',
                                            style: TextStyle(
                                                color: ScreenColor.textLight),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    LabeledTextField2(
                                      label: 'Pan Card Number',
                                      hintText: userInfoController.panNo.value,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Pan Card Photo',
                                          style: TextStyle(
                                            color: ScreenColor.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _showImageDialog(userInfoController
                                                .panImg.value);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(90, 46),
                                            backgroundColor:
                                                ScreenColor.primary,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'View Image',
                                            style: TextStyle(
                                                color: ScreenColor.textLight),
                                          ),
                                        ),
                                      ],
                                    ),
                                    LabeledTextField2(
                                      label: 'Employee Type',
                                      hintText:
                                          userInfoController.empType.value,
                                    ),
                                    const SizedBox(height: 10),
                                    LabeledTextField2(
                                      label: 'Monthly Income ',
                                      hintText:
                                          userInfoController.mincome.value,
                                    ),
                                    Text(
                                      userInfoController.empType.value ==
                                              'Company Worker'
                                          ? 'Form 16 and Bank Statement'
                                          : 'IT Return of Two Years',
                                      style: const TextStyle(
                                        color: ScreenColor.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          userInfoController.empType.value ==
                                                  'Company Worker'
                                              ? 'Form 16'
                                              : 'First Year',
                                          style: const TextStyle(
                                            color: ScreenColor.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _showImageDialog(userInfoController
                                                .itReturnImg.value);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(90, 46),
                                            backgroundColor:
                                                ScreenColor.primary,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'View Image',
                                            style: TextStyle(
                                                color: ScreenColor.textLight),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          userInfoController.empType.value ==
                                                  'Company Worker'
                                              ? 'Bank Statement'
                                              : 'Second Year',
                                          style: const TextStyle(
                                            color: ScreenColor.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _showImageDialog(userInfoController
                                                .secondImg.value);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(90, 46),
                                            primary: ScreenColor.primary,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'View Image',
                                            style: TextStyle(
                                                color: ScreenColor.textLight),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    });
  }

  void _approveLoan(String documentId) async {
    try {
      final DocumentReference userDocument =
          FirebaseFirestore.instance.collection('Loan').doc(documentId);

      final DocumentSnapshot loanSnapshot = await userDocument.get();
      final Map<String, dynamic>? loanData =
          loanSnapshot.data() as Map<String, dynamic>?;

      String? agentId = loanData?['AgentId'] as String?;

      if (agentId == null) {
        print('Error: agentId is null in Loan document');
        return;
      }

      print('Fetched agentId from Loan document: $agentId');
      await userDocument.update({
        'Status': 'approved',
      });
      QuerySnapshot agentsQuery = await FirebaseFirestore.instance
          .collection('Agents')
          .where('AgentId', isEqualTo: agentId)
          .get();

      if (agentsQuery.docs.isEmpty) {
        print('Error: AgentId not found in any Agents document');
        return;
      }
      DocumentSnapshot agentDocumentSnapshot = agentsQuery.docs.first;
      String agentDocumentId = agentDocumentSnapshot.id;
      Map<String, dynamic>? agentData =
          agentDocumentSnapshot.data() as Map<String, dynamic>?;

      print('Fetched AgentId from Agents document: ${agentData?['AgentId']}');

      if (agentData != null) {
        int currentMonth = agentData['Month'] as int? ?? 0;
        int currentYear = agentData['Year'] as int? ?? 0;
        int newMonth = currentMonth + 1;
        int newYear = currentYear + 1;

        await FirebaseFirestore.instance
            .collection('Agents')
            .doc(agentDocumentId)
            .update({
          'Month': newMonth,
          'Year': newYear,
        });

        print(
            'Loan approved for documentId: $documentId. Month incremented to $newMonth in Agents document: $agentDocumentId');
      } else {
        print('Error: agentData is null in Agents document: $agentDocumentId');
      }
    } catch (error) {
      print('Error approving loan: $error');
    }
  }

  void _denyLoan(String documentId) async {
    try {
      final DocumentReference userDocument =
          FirebaseFirestore.instance.collection('Loan').doc(documentId);
      await userDocument.update({
        'Status': 'denied',
      });

      print('Loan denied for documentId: $documentId');
    } catch (error) {
      print('Error approving loan: $error');
    }
  }
}

class LabeledTextField2 extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? hintText;
  final VoidCallback? onTap;
  final Widget? suffixWidget;
  final TextEditingController? controller;
  final String? regexPattern;

  const LabeledTextField2({
    super.key,
    required this.label,
    this.hintText,
    this.onTap,
    this.icon,
    this.suffixWidget,
    this.controller,
    this.regexPattern,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          width: 700,
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ScreenColor.textdivider),
              ),
              suffixIcon: icon != null
                  ? InkWell(
                      onTap: onTap,
                      child: Icon(icon),
                    )
                  : suffixWidget,
            ),
            cursorColor: ScreenColor.textPrimary,
            validator: (value) {
              if (regexPattern != null && value != null) {
                final RegExp regex = RegExp(regexPattern!);
                if (!regex.hasMatch(value)) {
                  return 'Invalid format';
                }
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
