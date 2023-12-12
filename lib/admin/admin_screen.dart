import 'package:fl_chart/fl_chart.dart';
import 'package:finkin_admin/screencolor/screen_color.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<double> monthlyData = [30, 50, 80, 40, 60, 90, 70, 100, 50, 80, 120, 90];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 230,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ScreenColor.primary, ScreenColor.combination],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Image.asset(
                    'assets/images/logo1.png',
                    fit: BoxFit.cover,
                  ),
                ),
                buildDrawerItem(Icons.dashboard, 'Dashboard', () {
                 
                }),
                buildDrawerItem(Icons.people, 'Loan Request', () {
                 
                }),
                buildDrawerItem(Icons.check_circle, 'Approved Loans', () {
                 
                }),
                buildDrawerItem(Icons.monetization_on, 'All Loans', () {
                 
                }),
                buildDrawerItem(Icons.people, 'All Users', () {
                  
                }),
                buildDrawerItem(Icons.supervised_user_circle, 'All Agents', () {
                  
                }),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ScreenColor.primary, ScreenColor.textPrimary],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 200,
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
                            margin: 20,
                            getTitles: (value) {
                              switch (value.toInt()) {
                                case 20:
                                  return '2022';
                                case 40:
                                  return '2023';
                                case 60:
                                  return '2024';
                                case 80:
                                  return '2025';
                                case 100:
                                  return '2026';
                                default:
                                  return '';
                              }
                            },
                          ),
                          rightTitles: SideTitles(showTitles: false),
                          topTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(showTitles: false),
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
                              (index) =>
                                  FlSpot(index.toDouble(), monthlyData[index]),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 160),
                  child: Row(
                    children: [
                      Container(
                        width: 280,
                        height: 200,
                        margin: const EdgeInsets.all(22.0),
                        decoration: BoxDecoration(
                          color: ScreenColor.textLight,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: ScreenColor.textdivider.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(''),
                        ),
                      ),
                      Container(
                        width: 280,
                        height: 200,
                        margin: const EdgeInsets.all(22.0),
                        decoration: BoxDecoration(
                          color: ScreenColor.textLight,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                             color: ScreenColor.textdivider.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(''),
                        ),
                      ),
                      Container(
                        width: 280,
                        height: 200,
                        margin: const EdgeInsets.all(22.0),
                        decoration: BoxDecoration(
                        color: ScreenColor.textLight,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: ScreenColor.textdivider.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(''),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Row(
                    children: [
                      Container(
                        width: 400,
                        height: 72,
                        margin: const EdgeInsets.all(22.0),
                        decoration: BoxDecoration(
                          color: ScreenColor.textLight,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                             color: ScreenColor.textdivider.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(''),
                        ),
                      ),
                      Container(
                        width: 400,
                        height: 72,
                        margin: const EdgeInsets.all(22.0),
                        decoration: BoxDecoration(
                         color: ScreenColor.textLight,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: ScreenColor.textdivider.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(''),
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
    );
  }

  Widget buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListTile(
        leading: Icon(icon, color: ScreenColor.textLight),
        title:
            Text(title, style: const TextStyle(color: ScreenColor.textLight)),
        onTap: onTap,
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: AdminScreen(),
    ),
  );
}
