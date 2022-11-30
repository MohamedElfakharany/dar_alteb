// To parse this JSON data, do
//
//     final homeAppointmentsModel = homeAppointmentsModelFromJson(jsondynamic);

import 'dart:convert';

HomeAppointmentsModel homeAppointmentsModelFromJson(dynamic str) => HomeAppointmentsModel.fromJson(json.decode(str));

class HomeAppointmentsModel {
  HomeAppointmentsModel({
    this.status,
    this.message,
    this.data,
    this.extra,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<HomeAppointmentsDataModel>? data;
  Extra? extra;
  Errors? errors;

  factory HomeAppointmentsModel.fromJson(Map<dynamic, dynamic> json) => HomeAppointmentsModel(
    status: json["status"],
    message: json["message"],
    data: List<HomeAppointmentsDataModel>.from(json["data"].map((x) => HomeAppointmentsDataModel.fromJson(x))),
    extra: Extra.fromJson(json["extra"]),
    errors: Errors.fromJson(json["errors"]),
  );
}

class HomeAppointmentsDataModel {
  HomeAppointmentsDataModel({
    this.from,
    this.from24,
    this.to,
    this.availablePatient,
    this.isUsed,
  });

  dynamic from;
  dynamic from24;
  dynamic to;
  dynamic availablePatient;
  dynamic isUsed;

  factory HomeAppointmentsDataModel.fromJson(Map<dynamic, dynamic> json) => HomeAppointmentsDataModel(
    from: json["from"],
    from24: json["from24"],
    to: json["to"],
    availablePatient: json["availablePatient"],
    isUsed: json["isUsed"],
  );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );
}

class Extra {
  Extra({
    this.date,
  });

  dynamic date;

  factory Extra.fromJson(Map<dynamic, dynamic> json) => Extra(
    date: json["date"],
  );
}