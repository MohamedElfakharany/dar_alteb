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
    status: json["status"],
    message: json["message"],
    data: List<LabResultsDataModel>.from(json["data"].map((x) => LabResultsDataModel.fromJson(x))),
    extra: Extra.fromJson(json["extra"]),
    errors: Errors.fromJson(json["errors"]),
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
  LabResultsDateModel? date;
  List<LabResultsDataFileModel>? results;

  factory LabResultsDataModel.fromJson(Map<dynamic, dynamic> json) => LabResultsDataModel(
    id: json["id"],
    countResult: json["countResult"],
    date: LabResultsDateModel.fromJson(json["date"]),
    results: List<LabResultsDataFileModel>.from(json["results"].map((x) => LabResultsDataFileModel.fromJson(x))),
  );
}

class LabResultsDateModel {
  LabResultsDateModel({
    this.date,
    this.time,
  });

  dynamic date;
  dynamic time;

  factory LabResultsDateModel.fromJson(Map<dynamic, dynamic> json) => LabResultsDateModel(
    date: json["date"],
    time: json["time"],
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
  LabResultsDateModel? date;
  dynamic notes;

  factory LabResultsDataFileModel.fromJson(Map<dynamic, dynamic> json) => LabResultsDataFileModel(
    id: json["id"],
    file: json["file"],
    title: json["title"],
    date: LabResultsDateModel.fromJson(json["date"]),
    notes: json["notes"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
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
