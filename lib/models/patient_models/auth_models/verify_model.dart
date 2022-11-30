import 'dart:convert';

SuccessModel successModelFromJson(dynamic str) =>
    SuccessModel.fromJson(json.decode(str));

class SuccessModel {
  SuccessModel({
    this.status,
    this.message,
  });

  dynamic status;
  dynamic message;

  factory SuccessModel.fromJson(Map<dynamic, dynamic> json) =>
      SuccessModel(status: json["status"], message: json["message"]);
}
