import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  List<double> monthlyData = [30, 50, 80, 40, 60, 90, 70, 100, 50, 80, 120, 90];

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
                    buildDrawerItem(Icons.dashboard, 'Dashboard', () {}),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.people, 'Loan Request', () {}),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(
                        Icons.check_circle, 'Approved Loans', () {}),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.monetization_on, 'All Loans', () {}),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(Icons.people, 'All Users', () {}),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDrawerItem(
                        Icons.supervised_user_circle, 'All Agents', () {}),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            body: buildBody(),
          );
        } else {
          // In desktop mode, use Scaffold without an AppBar
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
                      buildDrawerItem(Icons.dashboard, 'Dashboard', () {}),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(Icons.people, 'Loan Request', () {}),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(
                          Icons.check_circle, 'Approved Loans', () {}),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(
                          Icons.monetization_on, 'All Loans', () {}),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(Icons.people, 'All Users', () {}),
                      const SizedBox(
                        height: 15,
                      ),
                      buildDrawerItem(
                          Icons.supervised_user_circle, 'All Agents', () {}),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: buildBody(),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [ScreenColor.primary, ScreenColor.textPrimary],
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
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 290.0, left: 16.0),
              child: buildContainer(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 16.0),
              child: buildTwoContainer(),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildContainer() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
          ),
        ),
        Expanded(
          child: Container(
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
          ),
        ),
        Expanded(
          child: Container(
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
          ),
        ),
      ],
    );
  }

  Widget buildTwoContainer() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 150,
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
          ),
        ),
        Expanded(
          child: Container(
            height: 150,
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
          ),
        ),
      ],
    );
  }

  Widget buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: ScreenColor.textLight),
      title: Text(title, style: const TextStyle(color: ScreenColor.textLight)),
      onTap: onTap,
    );
  }
}
