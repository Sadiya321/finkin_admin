import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_admin/res/constants/enums/enums.dart';
import 'package:flutter/material.dart';

class LoanModel {
  final String? id;
  final String userImage;
  final String userId;
  final String agentId;
  final String agentName;
  final String aadharImg;
  final String panImg;
  final String userName;
  final String loanType;
  final DateTime date;
  final LoanStatus status;
  final String phone;
  final String email;
  final String panNo;
  final String aadharNo;
  final String address;
  final String image;
  final String income;
  final String form16img;
  final String bankImg;
  final String itReturnImg;
  final String secondImg;
  final String monthlyIncome;
  final String nationality;
  final String empType;
  final String pin;
  final bool isGranted;
  final String panNoCpy;
   final String logo;
  

  LoanModel(
      {this.id,
      required this.userId,
      required this.agentId,
      required this.empType,
      required this.panNoCpy,
      required this.nationality,
      required this.pin,
      required this.userImage,
      required this.agentName,
      required this.userName,
      required this.aadharImg,
      required this.panImg,
      required this.loanType,
      required this.date,
      required this.phone,
      required this.address,
      required this.email,
      required this.aadharNo,
      required this.panNo,
      required this.image,
      required this.form16img,
      required this.bankImg,
      required this.itReturnImg,
      required this.secondImg,
      required this.income,
      required this.monthlyIncome,
      required this.isGranted,
       required this.logo,
      this.status = LoanStatus.pending});

  toJson() {
    return {
      "UserId": userId,
      "AgentId": agentId,
      "UserName": userName,
      "Nationality": nationality,
      "EmpType": empType,
      "Pin": pin,
      "AgentName": agentName,
      "AadharImg": aadharImg,
      "UserImage": userImage,
      "Email": email,
      "LoanType": loanType,
      "Date": date,
      "Phone": phone,
      "PanImg": panImg,
      "Pan": panNo,
      "Address": address,
      "AadharNo": aadharNo,
      "Status": status.name,
      "isGranted": isGranted,
      "Form16Img": form16img,
      "ItReturnImg": itReturnImg,
      "SecondImg": secondImg,
      "BankImg": bankImg,
      "Income": income,
      "MonthlyIncome": monthlyIncome,
      "PanNoCpy": panNoCpy,
      "Logo": logo,
    };
  }

  factory LoanModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return LoanModel(
      id: document.id,
      userId: data?["UserId"] ?? "",
      panNoCpy: data?["PanNoCpy"] ?? "",
      userImage: data?["UserImage"] ?? "",
      empType: data?["EmpType"] ?? "",
      nationality: data?["Nationality"] ?? "",
      pin: data?["Pin"] ?? "",
      agentId: data?["AgentId"] ?? "",
      userName: data?["UserName"] ?? "",
      form16img: data?["Form16Img"] ?? "",
      income: data?["Income"] ?? "",
      bankImg: data?["BankImg"] ?? "",
      agentName: data?["AgentName"] ?? "",
      phone: data?["Phone"] ?? "",
      email: data?["Email"] ?? "",
      aadharNo: data?["AadharNo"] ?? "",
      panNo: data?["PanNo"] ?? "",
      address: data?["Address"] ?? "",
      status: _getStatusFromString(data?["Status"]),
      aadharImg: data?['AadharImg'] ?? "",
      panImg: data?['PanImg'] ?? "",
      monthlyIncome: data?['MonthlyIncome'] ?? "",
      loanType: data?['LoanType'] ?? "",
      isGranted: data?['isGranted'] ?? false,
      date: (data?['Date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      image: data?['Image'] ?? "",
      itReturnImg: data?["ItReturnImg"] ?? "",
      secondImg: data?["SecondImg"] ?? "",
      logo: data?["Logo"] ?? "",
    );
  }
  String get combinedIncome {
    return '$monthlyIncome$income';
  }

  static LoanStatus _getStatusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return LoanStatus.pending;
      case 'approved':
        return LoanStatus.approved;
      case 'denied':
        return LoanStatus.denied;
      default:
        return LoanStatus.pending;
    }
  }

  IconData get icon => loanStatusIcons[status] ?? Icons.no_accounts;
  final Map<LoanStatus, IconData> loanStatusIcons = {
    LoanStatus.pending: Icons.hourglass_top_outlined,
    LoanStatus.approved: Icons.check_circle,
    LoanStatus.denied: Icons.cancel_outlined
  };
}
