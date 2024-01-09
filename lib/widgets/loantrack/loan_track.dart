import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanTrack extends StatelessWidget {
  final String imageAsset;
  final String userName;
  final String loanType;
  final DateTime date;
  final IconData icon;
  final LoanStatus status;
  final Function() onPressed;

  const LoanTrack({
    Key? key,
    required this.imageAsset,
    required this.userName,
    required this.loanType,
    required this.onPressed,
    required this.date,
    required this.icon,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = constraints.maxWidth;

        // Define scaling factors based on screen width
        final imageScaleFactor = screenSize < 600 ? 0.1 : 0.04;
        final fontSize16 = screenSize * 0.01;
        final fontSize10 = screenSize * 0.01;
        final fontSize12 = screenSize * 0.01;

        return GestureDetector(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: SizedBox(
                          width: screenSize * imageScaleFactor,
                          height: screenSize * imageScaleFactor,
                          child: Image.network(
                            imageAsset,
                            width: screenSize * imageScaleFactor,
                            height: screenSize * imageScaleFactor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: fontSize16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            loanType,
                            style: TextStyle(fontSize: fontSize10),
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            icon,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        DateFormat.yMMMd().format(date),
                        style: TextStyle(fontSize: fontSize12),
                      ),
                      // Adjust font size dynamically based on the screen width
                      Text(
                        "Status",
                        style: TextStyle(fontSize: fontSize12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                       backgroundColor: Colors.lightBlueAccent
                    ),
                    child: const Text('Open'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}