// To parse this JSON data, do
//
//     final offersModel = offersModelFromJson(jsondynamic);

import 'dart:convert';

OffersModel offersModelFromJson(dynamic str) => OffersModel.fromJson(json.decode(str));

class OffersModel {
  OffersModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<OffersDataModel>? data;
  Errors? errors;

  factory OffersModel.fromJson(Map<dynamic, dynamic> json) => OffersModel(
    status: json["status"],
    message: json["message"],
    data: List<OffersDataModel>.from(json["data"].map((x) => OffersDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class OffersDataModel {
  OffersDataModel({
    this.id,
    this.image,
    this.title,
    this.description,
    this.preparation,
    this.gender,
    this.price,
    this.discount,
    this.isPercentage,
    this.total,
    this.expireDate,
    this.tests,
  });

  dynamic id;
  dynamic image;
  dynamic title;
  dynamic description;
  dynamic preparation;
  dynamic gender;
  dynamic price;
  dynamic discount;
  dynamic isPercentage;
  dynamic total;
  dynamic expireDate;
  List<OffersTestDataModel>? tests;

  factory OffersDataModel.fromJson(Map<dynamic, dynamic> json) => OffersDataModel(
    id: json["id"],
    image: json["image"],
    title: json["title"],
    description: json["description"],
    preparation: json["preparation"],
    gender: json["gender"],
    price: json["price"],
    discount: json["discount"],
    isPercentage: json["is_percentage"],
    total: json["total"],
    expireDate: json["expire_date"],
    tests: List<OffersTestDataModel>.from(json["tests"].map((x) => OffersTestDataModel.fromJson(x))),
  );

}

class OffersTestDataModel {
  OffersTestDataModel({
    this.id,
    this.name,
    this.price,
  });

  dynamic id;
  dynamic name;
  dynamic price;

  factory OffersTestDataModel.fromJson(Map<dynamic, dynamic> json) => OffersTestDataModel(
    id: json["id"],
    name: json["name"],
    price: json["price"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}