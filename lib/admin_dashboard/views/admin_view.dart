import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/login/views/login_view.dart';
import 'package:finkin_admin/widgets/all_agents_content/all_agents_content.dart';
import 'package:finkin_admin/widgets/all_loans_content/all_loans_content.dart';
import 'package:finkin_admin/widgets/all_users_content/all_users_content.dart';
import 'package:finkin_admin/widgets/approved_loans_content/approved_loans_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_data_controller/adminData_controller.dart';
import '../../controller/auth_controller/auth_controller.dart';
import '../../widgets/loan_request_content/loan_request_content.dart';

class AdminView extends StatefulWidget {
  final String documentId;
  const AdminView({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final _auth = FirebaseAuth.instance;
  final AuthController authController = Get.put(AuthController());
  List<double> monthlyData = [30, 50, 80, 40, 60, 90, 70, 100, 50, 80, 120, 90];
  final AdminDataController adminDataController =
      Get.put(AdminDataController());
  String selectedContent = 'Dashboard';
  // final GlobalKey<LoanRequestState> loanRequestKey = GlobalKey();
  void onDrawerItemClicked(String content) {
    setState(() {
      selectedContent = content;
    });
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      print("User signed out");
      Get.offAll(HomePage());
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Logout Confirmation",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Do you want to Log Out?"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: ScreenColor.primary,
                      ),
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: ScreenColor.primary,
                      ),
                      child: const Text("Yes"),
                      onPressed: () {
                        _signOut();
                      },
                    ),
                  ],
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin DashBoard'),
            ),
            drawer: Drawer(
              child: Container(
                width: 230,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.zero),
                  gradient: LinearGradient(
                    colors: [ScreenColor.primary, ScreenColor.combination],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: Image.asset(
                        'assets/images/logo1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    buildDrawerItem(Icons.dashboard, 'Dashboard', () {
                      onDrawerItemClicked('Dashboard');
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.people, 'Loan Request', () {
                      onDrawerItemClicked('Loan Request');
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.check_circle, 'Approved Loans', () {
                      onDrawerItemClicked('Approved Loans');
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.monetization_on, 'All Loans', () {
                      onDrawerItemClicked('All Loans');
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.people, 'All Users', () {
                      onDrawerItemClicked('All Users');
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.supervised_user_circle, 'All Agents',
                        () {
                      onDrawerItemClicked('All Agents');
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.logout, 'Log Out', () {
                      onDrawerItemClicked('Log Out');
                    }),
                  ],
                ),
              ),
            ),
            body: buildBody(selectedContent),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                Container(
                  width: 230,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.zero),
                    gradient: LinearGradient(
                      colors: [ScreenColor.primary, ScreenColor.combination],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 180,
                        child: Image.asset(
                          'assets/images/logo1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      buildDrawerItem(Icons.dashboard, 'Dashboard', () {
                        onDrawerItemClicked('Dashboard');
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(Icons.people, 'Loan Request', () {
                        onDrawerItemClicked('Loan Request');
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(Icons.check_circle, 'Approved Loans', () {
                        onDrawerItemClicked('Approved Loans');
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(Icons.monetization_on, 'All Loans', () {
                        onDrawerItemClicked('All Loans');
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(Icons.people, 'All Users', () {
                        onDrawerItemClicked('All Users');
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(
                          Icons.supervised_user_circle, 'All Agents', () {
                        onDrawerItemClicked('All Agents');
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(Icons.logout, 'Log Out', () {
                        onDrawerItemClicked('Log Out');
                      }),
                    ],
                  ),
                ),
                Expanded(
                  child: buildBody(selectedContent),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildBody(String selectedContent) {
    switch (selectedContent) {
      case 'Dashboard':
        return buildDashboardContent();
      case 'Loan Request':
        return buildLoanRequestContent();
      case 'Approved Loans':
        return buildApprovedLoansContent();
      case 'All Loans':
        return buildAllLoansContent();
      case 'All Users':
        return buildAllUsersContent();
      case 'All Agents':
        return buildAllAgentsContent();

      default:
        return buildDefaultContent();
    }
  }

  Widget buildDashboardContent() {
    return FutureBuilder<List<String?>>(
      future: adminDataController.getAdminData(authController.adminId.value),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              automaticallyImplyLeading: false,
              actions: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
            body: Container(),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              automaticallyImplyLeading: false,
              actions: [
                Text('Error: ${snapshot.error}'),
                const SizedBox(width: 20),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
            body: Container(),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              automaticallyImplyLeading: false,
              actions: const [
                Text('No data available'),
                SizedBox(width: 20),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
            body: Container(),
          );
        } else {
          String agentName = snapshot.data?[0] ?? "Defaulte Name";
          String? agentImage = snapshot.data?[1];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              automaticallyImplyLeading: false,
              actions: [
                Text(agentName),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: agentImage != null
                        ? NetworkImage(agentImage)
                        : const AssetImage('assets/images/hill.png')
                            as ImageProvider<Object>?,
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ScreenColor.primary,
                            ScreenColor.textPrimary
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: false,
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                margin: 0,
                                getTitles: (value) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return '0';
                                    case 20:
                                      return '2023';
                                    case 40:
                                      return '2024';
                                    case 60:
                                      return '2025';
                                    case 80:
                                      return '2026';
                                    case 100:
                                      return '2027';
                                    default:
                                      return '';
                                  }
                                },
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            minX: 0,
                            maxX: monthlyData.length.toDouble(),
                            minY: 0,
                            maxY: 120,
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  monthlyData.length,
                                  (index) => FlSpot(
                                    index.toDouble(),
                                    monthlyData[index],
                                  ),
                                ),
                                isCurved: true,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 290.0, left: 16.0),
                    child: buildContainer(),
                  ),
                ]),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildLoanRequestContent() {
    return const LoanRequest();
  }

  Widget buildApprovedLoansContent() {
    return const ApprovedLoans();
  }

  Widget buildAllLoansContent() {
    return const AllLoans();
  }

  Widget buildAllUsersContent() {
    return const AllUsers();
  }

  Widget buildAllAgentsContent() {
    return const AllAgents();
  }

  Widget buildDefaultContent() {
    return const Text('Select an item from the drawer to view content.');
  }

  Widget buildContainer() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: 200,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: ScreenColor.textLight,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: ScreenColor.textdivider.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      top: 20,
                      child: Image(
                        image: AssetImage('assets/images/Vector.png'),
                        width: 40,
                        height: 75,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: Column(
                        children: [
                          Text(
                            '5623',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
                          ),
                          Text(
                            'Total Loans',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
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
        Expanded(
          child: Column(
            children: [
              Container(
                height: 200,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: ScreenColor.textLight,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: ScreenColor.textdivider.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      top: 20,
                      child: Image(
                        image: AssetImage('assets/images/_Accountant_.png'),
                        width: 40,
                        height: 75,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: Column(
                        children: [
                          Text(
                            '5623',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
                          ),
                          Text(
                            'Total Users',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
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
        Expanded(
          child: Column(
            children: [
              Container(
                height: 200,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: ScreenColor.textLight,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: ScreenColor.textdivider.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      top: 20,
                      child: Image(
                        image: AssetImage('assets/images/icon _co_.png'),
                        width: 40,
                        height: 75,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: Column(
                        children: [
                          Text(
                            '5623',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
                          ),
                          Text(
                            'Total Agents',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
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

  // Widget buildTwoContainer() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           height: 150,
  //           margin: const EdgeInsets.all(8.0),
  //           decoration: BoxDecoration(
  //             color: ScreenColor.textLight,
  //             borderRadius: BorderRadius.circular(5),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: ScreenColor.textdivider.withOpacity(0.2),
  //                 spreadRadius: 5,
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 3),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: Container(
  //           height: 150,
  //           margin: const EdgeInsets.all(8.0),
  //           decoration: BoxDecoration(
  //             color: ScreenColor.textLight,
  //             borderRadius: BorderRadius.circular(5),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: ScreenColor.textdivider.withOpacity(0.2),
  //                 spreadRadius: 5,
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 3),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: ScreenColor.textLight),
      title: Text(title, style: const TextStyle(color: ScreenColor.textLight)),
      onTap: () {
        if (title == 'Log Out') {
          showLogoutConfirmationDialog(context);
        } else {
          onTap();
        }
      },
    );
  }
}
