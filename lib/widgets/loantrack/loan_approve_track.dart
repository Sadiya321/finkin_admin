import 'package:finkin_admin/common/utils/screen_color.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanAppTrack extends StatelessWidget {
  final String imageAsset;
  final String userName;
  final String loanType;
  final String email;
  final String pin;
  final String phone;
  final String panNo;
  final DateTime date;
  final String aadharNo;
  final String nationality;
  final String address;
  final String empType;
  final String income;
  final DateTime dob;
  final IconData icon;
  final IconData downloadIcon;
  final LoanStatus status;
  final Function() onPressed;
  final Function() onDownloadPressed;

  const LoanAppTrack({
    Key? key,
    required this.imageAsset,
    required this.userName,
    required this.loanType,
    required this.onPressed,
    required this.onDownloadPressed,
    required this.date,
    required this.icon,
    required this.downloadIcon,
    required this.status,
    required this.panNo,
    required this.phone,
    required this.pin,
    required this.email,
    required this.aadharNo,
    required this.nationality,
    required this.address,
    required this.empType,
    required this.income,
    required this.dob,
  }) : super(key: key);

   @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    final imageScaleFactor = screenSize < 600 ? 0.1 : 0.04;
    final fontSize16 = screenSize * 0.01;
    final fontSize10 = screenSize * 0.01;
    final fontSize12 = screenSize * 0.01;

    final formattedDate = DateFormat.yMMMd().format(date);

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(screenSize < 600 ? 8.0 : 10.0),
          decoration: BoxDecoration(
            color: ScreenColor.textLight,
            borderRadius: BorderRadius.circular(screenSize < 600 ? 16.0 : 26.0),
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
                    borderRadius: BorderRadius.circular(screenSize < 600 ? 12.0 : 22.0),
                    child: SizedBox(
                      width: screenSize < 600 ? 36 : screenSize * imageScaleFactor,
                      height: screenSize < 600 ? 36 : screenSize * imageScaleFactor,
                      child: Image.network(
                        imageAsset,
                        width: screenSize < 600 ? 36 : screenSize * imageScaleFactor,
                        height: screenSize < 600 ? 36 : screenSize * imageScaleFactor,
                        fit: BoxFit.cover,
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
                          fontSize: screenSize < 600 ? 14 : fontSize16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        loanType,
                        style: TextStyle(fontSize: screenSize < 600 ? 16 : fontSize10),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: ScreenColor.icon,
                        size: screenSize < 600 ? 20 : 24,
                      ),
                      IconButton(
                        onPressed: onDownloadPressed,
                        icon: Icon(
                          downloadIcon,
                          color: ScreenColor.icon,
                          size: screenSize < 600 ? 20 : 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: screenSize < 600 ? 10 : fontSize12),
                  ),
                  Text(
                    status.name,
                    style: TextStyle(fontSize: screenSize < 600 ? 10 : fontSize12),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust button padding
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text('Open', style: TextStyle(fontSize: screenSize < 600 ? 10 : fontSize10)), // Adjust text size for mobile
              ),
            ],
          ),
        ),
      ),
    );
  }
}