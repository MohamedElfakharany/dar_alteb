// To parse this JSON data, do
//
//     final termsModel = termsModelFromJson(jsondynamic);

import 'dart:convert';

TermsModel termsModelFromJson(dynamic str) => TermsModel.fromJson(json.decode(str));

class TermsModel {
  TermsModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  TermsDataModel? data;
  Errors? errors;

  factory TermsModel.fromJson(Map<dynamic, dynamic> json) => TermsModel(
    status: json["status"],
    message: json["message"],
    data: TermsDataModel.fromJson(json["data"]),
    errors: Errors.fromJson(json["errors"]),
  );
}

class TermsDataModel {
  TermsDataModel({
    this.terms,
    this.privacy,
  });

  dynamic terms;
  dynamic privacy;

  factory TermsDataModel.fromJson(Map<dynamic, dynamic> json) => TermsDataModel(
    terms: json["terms"],
    privacy: json["privacy"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}
