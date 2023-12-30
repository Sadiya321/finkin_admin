import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserInfoController extends GetxController {
  var fullName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var dob = ''.obs;
  var address = ''.obs;
  var imageUrl = ''.obs;
  var userImage = ''.obs;
  var userid = ''.obs;
  var status = ''.obs;
  var agentImg = ''.obs;
  var aadharImg = ''.obs;
  var panImg = ''.obs;
  var secondImg = ''.obs;
  var itReturnImg = ''.obs;
  var form16Img = ''.obs;
  var bankImg = ''.obs;
  var currentStep = 1.obs;
  var isLoading = true.obs;
  var aadharNo = ''.obs;
  var pin = ''.obs;
  var nation = ''.obs;
  var panNo = ''.obs;
  var mincome = ''.obs;
  var empType = ''.obs;

  Future<void> fetchUserDetails(String docId) async {
    try {
      isLoading(true);
      print("Fetching user details for agentId: $docId");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Loan')
          .where('docId', isEqualTo: docId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();
        print("User details fetched successfully: $userDoc");
        address.value = userDoc['Address'] ?? '';
        fullName.value = userDoc['UserName'] ?? '';
        email.value = userDoc['Email'] ?? '';
        phone.value = userDoc['Phone'] ?? '';
        userid.value = userDoc['AgentId'] ?? '';
        imageUrl.value = userDoc['AadharImg'] ?? '';
        status.value = userDoc['Status'] ?? '';
        aadharImg.value = userDoc['AadharImg'] ?? '';
        panImg.value = userDoc['PanImg'] ?? '';
        itReturnImg.value = userDoc['ItReturnImg'] ?? '';
        secondImg.value = userDoc['SecondImg'] ?? '';
        userImage.value = userDoc['UserImage'] ?? '';
        aadharNo.value = userDoc['AadharNo'] ?? '';
        pin.value = userDoc['Pin'] ?? '';
        nation.value = userDoc['Nationality'] ?? '';
        panNo.value = userDoc['Pan'] ?? '';
        mincome.value = userDoc['MonthlyIncome'] ?? '';
        empType.value = userDoc['EmpType'] ?? '';
        Timestamp timestamp = userDoc['Date'];
        DateTime dateTime = timestamp.toDate();
        dob.value = DateFormat('dd-MM-yyyy').format(dateTime);
        _updateCurrentStep(status.value);
        if (empType.value == 'Company Worker') {
          // If yes, update the observable accordingly
          mincome.value = userDoc['Income'] ?? '';
          itReturnImg.value = userDoc['Form16Img'] ?? '';
          secondImg.value = userDoc['BankImg'] ??
              ''; // Change this to the desired value or logic
        } else {
          // If no, update it with the value from Firestore
          itReturnImg.value = userDoc['ItReturnImg'] ?? '';
        }
      } else {
        print("User with agentId $docId not found");
      }
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  // void clearControllerValues() {
  //   address.value = '';
  //   fullName.value = '';
  //   email.value = '';
  //   phone.value = '';
  //   userid.value = '';
  //   imageUrl.value = '';
  //   status.value = '';
  //   aadharImg.value = '';
  //   panImg.value = '';
  //   itReturnImg.value = '';
  //   secondImg.value = '';
  // }

  Future<void> fetchAgentDetails(String agentId) async {
    try {
      isLoading(true);
      print("Fetching user details for agentId: $agentId");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Agents')
          .where('AgentId', isEqualTo: agentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();
        print("User details fetched successfully: $userDoc");

        agentImg.value = userDoc['ImageUrl'] ?? '';
      } else {
        // print("User with agentId $agentId not found");
        // Get.to(UserNav());
      }
    } catch (e) {
      print("Error fetching user details: $e");
    } finally {
      isLoading(false);
    }
  }

  void _updateCurrentStep(String status) {
    switch (status) {
      case 'pending':
        currentStep.value = 3;
        break;
      case 'approved':
        currentStep.value = 4;
        break;
      case 'denied':
        currentStep.value = 5;
        break;
      default:
        currentStep.value = 1;
    }
  }
}