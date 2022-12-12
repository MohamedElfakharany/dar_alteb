// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsondynamic);

import 'dart:convert';

AddressModel addressModelFromJson(dynamic str) => AddressModel.fromJson(json.decode(str));

class AddressModel {
  AddressModel({
    this.status,
    this.message,
    this.data,
    this.extra,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<AddressDataModel>? data;
  Extra? extra;
  Errors? errors;

  factory AddressModel.fromJson(Map<dynamic, dynamic> json) => AddressModel(
    status: json["status"],
    message: json["message"],
    data: List<AddressDataModel>.from(json["data"].map((x) => AddressDataModel.fromJson(x))),
    extra: Extra.fromJson(json["extra"]),
    errors: Errors.fromJson(json["errors"]),
  );
}

class AddressDataModel {
  AddressDataModel({
    this.id,
    this.address,
    this.specialMark,
    this.floorNumber,
    this.buildingNumber,
    this.title,
    this.isSelected,
  });

  dynamic id;
  dynamic address;
  dynamic specialMark;
  dynamic floorNumber;
  dynamic buildingNumber;
  dynamic title;
  dynamic isSelected;

  factory AddressDataModel.fromJson(Map<dynamic, dynamic> json) => AddressDataModel(
    id: json["id"],
    address: json["address"],
    specialMark: json["specialMark"],
    floorNumber: json["floorNumber"],
    title: json["title"],
    buildingNumber: json["buildingNumber"],
    isSelected: json["isSelected"],
  );
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

  Pagination? pagination;

  factory Extra.fromJson(Map<dynamic, dynamic> json) => Extra(
    pagination: Pagination.fromJson(json["pagination"]),
  );
}

class Pagination {
  Pagination({
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

  factory Pagination.fromJson(Map<dynamic, dynamic> json) => Pagination(
    total: json["total"],
    count: json["count"],
    perPage: json["perPage"],
    currentPage: json["currentPage"],
    lastPage: json["lastPage"],
  );
}
