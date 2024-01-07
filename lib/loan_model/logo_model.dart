import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';

class LogoModel {
  final String? id;
  final String logoImg;

LogoModel({
  this.id,
  required this.logoImg,
});

toJson() {
  return{
    "Id":id,
  "LogoImg" :logoImg,
  };
  

}
factory LogoModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return LogoModel(
      id: document.id,
      logoImg: data?["LogoImg"] ?? "",
    );
}
}