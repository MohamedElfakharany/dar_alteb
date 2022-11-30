// To parse this JSON data, do
//
//     final familiesModel = familiesModelFromJson(jsondynamic);

import 'dart:convert';

FamiliesModel familiesModelFromJson(dynamic str) => FamiliesModel.fromJson(json.decode(str));

class FamiliesModel {
  FamiliesModel({
    this.status,
    this.message,
    this.data,
    this.extra,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<FamiliesDataModel>? data;
  Extra? extra;
  Errors? errors;

  factory FamiliesModel.fromJson(Map<dynamic, dynamic> json) => FamiliesModel(
    status: json["status"],
    message: json["message"],
    data: List<FamiliesDataModel>.from(json["data"].map((x) => FamiliesDataModel.fromJson(x))),
    extra: Extra.fromJson(json["extra"]),
    errors: Errors.fromJson(json["errors"]),
  );
}

class FamiliesDataModel {
  FamiliesDataModel({
    this.id,
    this.relation,
    this.name,
    this.phone,
    this.phoneCode,
    this.birthday,
    this.gender,
    this.profile,
  });

  dynamic id;
  RelationFamiliesModel? relation;
  dynamic name;
  dynamic phoneCode;
  dynamic phone;
  dynamic birthday;
  dynamic gender;
  dynamic profile;

  factory FamiliesDataModel.fromJson(Map<dynamic, dynamic> json) => FamiliesDataModel(
    id: json["id"],
    relation: RelationFamiliesModel.fromJson(json["relation"]),
    name: json["name"],
    phone: json["phone"],
    phoneCode: json["phoneCode"],
    birthday: json["birthday"],
    gender: json["gender"],
    profile: json["profile"],
  );
}

class RelationFamiliesModel {
  RelationFamiliesModel({
    this.id,
    this.title,
  });

  dynamic id;
  dynamic title;

  factory RelationFamiliesModel.fromJson(Map<dynamic, dynamic> json) => RelationFamiliesModel(
    id: json["id"],
    title: json["title"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );

  Map<dynamic, dynamic> toJson() => {
  };
}

class Extra {
  Extra({
    this.pagination,
  });

  PaginationModel? pagination;

  factory Extra.fromJson(Map<dynamic, dynamic> json) => Extra(
    pagination: PaginationModel.fromJson(json["pagination"]),
  );
}

class PaginationModel {
  PaginationModel({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  dynamic total;
  dynamic count;
  dynamic perPage;
  dynamic currentPage;
  dynamic lastPage;

  factory PaginationModel.fromJson(Map<dynamic, dynamic> json) => PaginationModel(
    total: json["total"],
    count: json["count"],
    perPage: json["perPage"],
    currentPage: json["currentPage"],
    lastPage: json["lastPage"],
  );
}
