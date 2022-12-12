// To parse this JSON data, do
//
//     final labResultsModel = labResultsModelFromJson(jsondynamic);

import 'dart:convert';

LabResultsModel labResultsModelFromJson(dynamic str) => LabResultsModel.fromJson(json.decode(str));

class LabResultsModel {
  LabResultsModel({
    this.status,
    this.message,
    this.data,
    this.extra,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<LabResultsDataModel>? data;
  Extra? extra;
  Errors? errors;

  factory LabResultsModel.fromJson(Map<dynamic, dynamic> json) => LabResultsModel(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<LabResultsDataModel>.from(json["data"].map((x) => LabResultsDataModel.fromJson(x))),
    extra: json["extra"] == null ? null : Extra.fromJson(json["extra"]),
    errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
  );
}

class LabResultsDataModel {
  LabResultsDataModel({
    this.id,
    this.countResult,
    this.date,
    this.results,
  });

  dynamic id;
  dynamic countResult;
  Date? date;
  List<LabResultsDataFileModel>? results;

  factory LabResultsDataModel.fromJson(Map<dynamic, dynamic> json) => LabResultsDataModel(
    id: json["id"] == null ? null : json["id"],
    countResult: json["countResult"] == null ? null : json["countResult"],
    date: json["date"] == null ? null : Date.fromJson(json["date"]),
    results: json["results"] == null ? null : List<LabResultsDataFileModel>.from(json["results"].map((x) => LabResultsDataFileModel.fromJson(x))),
  );
}

class Date {
  Date({
    this.date,
    this.time,
  });

  dynamic date;
  dynamic time;

  factory Date.fromJson(Map<dynamic, dynamic> json) => Date(
    date: json["date"] == null ? null : json["date"],
    time: json["time"] == null ? null : json["time"],
  );
}

class LabResultsDataFileModel {
  LabResultsDataFileModel({
    this.id,
    this.file,
    this.title,
    this.date,
    this.notes,
  });

  dynamic id;
  dynamic file;
  dynamic title;
  Date? date;
  dynamic notes;

  factory LabResultsDataFileModel.fromJson(Map<dynamic, dynamic> json) => LabResultsDataFileModel(
    id: json["id"] == null ? null : json["id"],
    file: json["file"] == null ? null : json["file"],
    title: json["title"] == null ? null : json["title"],
    date: json["date"] == null ? null : Date.fromJson(json["date"]),
    notes: json["notes"] == null ? null : json["notes"],
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
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
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
    total: json["total"] == null ? null : json["total"],
    count: json["count"] == null ? null : json["count"],
    perPage: json["perPage"] == null ? null : json["perPage"],
    currentPage: json["currentPage"] == null ? null : json["currentPage"],
    lastPage: json["lastPage"] == null ? null : json["lastPage"],
  );
}
