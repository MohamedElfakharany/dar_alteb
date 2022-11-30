
import 'dart:convert';

BranchModel branchModelFromJson(dynamic str) => BranchModel.fromJson(json.decode(str));

class BranchModel {
  BranchModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<BranchesDataModel>? data;
  Errors? errors;

  factory BranchModel.fromJson(Map<dynamic, dynamic> json) => BranchModel(
    status: json["status"],
    message: json["message"],
    data: List<BranchesDataModel>.from(json["data"].map((x) => BranchesDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class BranchesDataModel {
  BranchesDataModel({
    this.id,
    this.title,
    this.address,
  });

  dynamic id;
  dynamic title;
  dynamic address;

  factory BranchesDataModel.fromJson(Map<dynamic, dynamic> json) => BranchesDataModel(
    id: json["id"],
    title: json["title"],
    address: json["address"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "title": title,
    "address": address,
  };
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );

  Map<dynamic, dynamic> toJson() => {
  };
}