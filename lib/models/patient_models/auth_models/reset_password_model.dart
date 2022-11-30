// To parse this JSON data, do
//
//     final resetPasswordModel = resetPasswordModelFromJson(jsondynamic);

import 'dart:convert';

ResetPasswordModel resetPasswordModelFromJson(dynamic str) => ResetPasswordModel.fromJson(json.decode(str));

class ResetPasswordModel {
  ResetPasswordModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  ResetPasswordDataModel? data;
  Errors? errors;

  factory ResetPasswordModel.fromJson(Map<dynamic, dynamic> json) => ResetPasswordModel(
    status: json["status"],
    message: json["message"],
    data: ResetPasswordDataModel.fromJson(json["data"]),
    errors: Errors.fromJson(json["errors"]),
  );
}

class ResetPasswordDataModel {
  ResetPasswordDataModel({
    this.resetToken,
  });

  dynamic resetToken;

  factory ResetPasswordDataModel.fromJson(Map<dynamic, dynamic> json) => ResetPasswordDataModel(
    resetToken: json["resetToken"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}
