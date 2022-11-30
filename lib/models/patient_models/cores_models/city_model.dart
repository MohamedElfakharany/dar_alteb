import 'dart:convert';

CityModel cityModelFromJson(dynamic str) => CityModel.fromJson(json.decode(str));

class CityModel {
  CityModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<CityDataModel>? data;
  Errors? errors;

  factory CityModel.fromJson(Map<dynamic, dynamic> json) => CityModel(
    status: json["status"],
    message: json["message"],
    data: List<CityDataModel>.from(json["data"].map((x) => CityDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class CityDataModel {
  CityDataModel({
    this.id,
    this.title,
  });

  dynamic id;
  dynamic title;

  factory CityDataModel.fromJson(Map<dynamic, dynamic> json) => CityDataModel(
    id: json["id"],
    title: json["title"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );

  Map<dynamic, dynamic> toJson() => {
  };
}