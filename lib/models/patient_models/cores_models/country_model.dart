

import 'dart:convert';

CountryModel getCountryModelFromJson(dynamic str) => CountryModel.fromJson(json.decode(str));

class CountryModel {
  CountryModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<CountryDataModel>? data;
  Errors? errors;

  factory CountryModel.fromJson(Map<dynamic, dynamic> json) => CountryModel(
    status: json["status"],
    message: json["message"],
    data: List<CountryDataModel>.from(json["data"].map((x) => CountryDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class CountryDataModel {
  CountryDataModel({
    this.id,
    this.title,
  });

  dynamic id;
  dynamic title;

  factory CountryDataModel.fromJson(Map<dynamic, dynamic> json) => CountryDataModel(
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