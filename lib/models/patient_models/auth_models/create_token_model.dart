// To parse this JSON data, do
//
//     final createTokenModel = createTokenModelFromJson(jsondynamic);

import 'dart:convert';

CreateTokenModel createTokenModelFromJson(dynamic str) => CreateTokenModel.fromJson(json.decode(str));

class CreateTokenModel {
  CreateTokenModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  CreateTokenDataModel? data;
  Errors? errors;

  factory CreateTokenModel.fromJson(Map<dynamic, dynamic> json) => CreateTokenModel(
    status: json["status"],
    message: json["message"],
    data: CreateTokenDataModel.fromJson(json["data"]),
    errors: Errors.fromJson(json["errors"]),
  );
}

class CreateTokenDataModel {
  CreateTokenDataModel({
    this.resetToken,
  });

  dynamic resetToken;

  factory CreateTokenDataModel.fromJson(Map<dynamic, dynamic> json) => CreateTokenDataModel(
    resetToken: json["resetToken"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}
