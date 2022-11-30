// To parse this JSON data, do
//
//     final testsModel = testsModelFromJson(jsondynamic);

import 'dart:convert';

TestsModel testsModelFromJson(dynamic str) => TestsModel.fromJson(json.decode(str));

class TestsModel {
  TestsModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<TestsDataModel>? data;
  Errors? errors;

  factory TestsModel.fromJson(Map<dynamic, dynamic> json) => TestsModel(
    status: json["status"],
    message: json["message"],
    data: List<TestsDataModel>.from(json["data"].map((x) => TestsDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class TestsDataModel {
  TestsDataModel({
    this.id,
    this.category,
    this.image,
    this.title,
    this.description,
    this.preparation,
    this.gender,
    this.price,
  });

  dynamic id;
  CategoryModel? category;
  dynamic image;
  dynamic title;
  dynamic description;
  dynamic preparation;
  dynamic gender;
  dynamic price;

  factory TestsDataModel.fromJson(Map<dynamic, dynamic> json) => TestsDataModel(
    id: json["id"],
    category: CategoryModel.fromJson(json["category"]),
    image: json["image"],
    title: json["title"],
    description: json["description"],
    preparation: json["preparation"],
    gender: json["gender"],
    price: json["price"],
  );
}

class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
  });

  dynamic id;
  dynamic name;

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) => CategoryModel(
    id: json["id"],
    name: json["name"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}
