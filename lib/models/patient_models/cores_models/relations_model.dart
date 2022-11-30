// To parse this JSON data, do
//
//     final relationsModel = relationsModelFromJson(jsondynamic);

import 'dart:convert';

RelationsModel relationsModelFromJson(dynamic str) => RelationsModel.fromJson(json.decode(str));

class RelationsModel {
  RelationsModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<RelationsDataModel>? data;
  Errors? errors;

  factory RelationsModel.fromJson(Map<dynamic, dynamic> json) => RelationsModel(
    status: json["status"],
    message: json["message"],
    data: List<RelationsDataModel>.from(json["data"].map((x) => RelationsDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class RelationsDataModel {
  RelationsDataModel({
    this.id,
    this.title,
  });

  dynamic id;
  dynamic title;

  factory RelationsDataModel.fromJson(Map<dynamic, dynamic> json) =>
      RelationsDataModel(
        id: json["id"],
        title: json["title"],
      );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}
