// To parse this JSON data, do
//
//     final carouselModel = carouselModelFromJson(jsondynamic);

import 'dart:convert';

CarouselModel carouselModelFromJson(dynamic str) => CarouselModel.fromJson(json.decode(str));

class CarouselModel {
  CarouselModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<CarouselDataModel>? data;
  Errors? errors;

  factory CarouselModel.fromJson(Map<dynamic, dynamic> json) => CarouselModel(
    status: json["status"],
    message: json["message"],
    data: List<CarouselDataModel>.from(json["data"].map((x) => CarouselDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class CarouselDataModel {
  CarouselDataModel({
    this.id,
    this.image,
    this.title,
    this.text,
  });

  dynamic id;
  dynamic image;
  dynamic title;
  dynamic text;

  factory CarouselDataModel.fromJson(Map<dynamic, dynamic> json) => CarouselDataModel(
    id: json["id"],
    image: json["image"],
    title: json["title"],
    text: json["text"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}
