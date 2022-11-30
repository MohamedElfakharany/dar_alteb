// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsondynamic);

import 'dart:convert';

CategoriesModel categoriesModelFromJson(dynamic str) => CategoriesModel.fromJson(json.decode(str));

class CategoriesModel {
  CategoriesModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<CategoriesDataModel>? data;
  Errors? errors;

  factory CategoriesModel.fromJson(Map<dynamic, dynamic> json) => CategoriesModel(
    status: json["status"],
    message: json["message"],
    data: List<CategoriesDataModel>.from(json["data"].map((x) => CategoriesDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class CategoriesDataModel {
  CategoriesDataModel({
    this.id,
    this.icon,
    this.title,
  });

  dynamic id;
  dynamic icon;
  dynamic title;

  factory CategoriesDataModel.fromJson(Map<dynamic, dynamic> json) => CategoriesDataModel(
    id: json["id"],
    icon: json["icon"],
    title: json["title"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}
