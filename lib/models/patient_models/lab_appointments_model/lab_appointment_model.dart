// To parse this JSON data, do
//
//     final labAppointmentsModel = labAppointmentsModelFromJson(jsondynamic);

import 'dart:convert';

LabAppointmentsModel labAppointmentsModelFromJson(dynamic str) => LabAppointmentsModel.fromJson(json.decode(str));

class LabAppointmentsModel {
  LabAppointmentsModel({
    this.status,
    this.message,
    this.data,
    this.extra,
  });

  dynamic status;
  dynamic message;
  List<LabAppointmentsDataModel>? data;
  LabAppointmentsExtraModel? extra;

  factory LabAppointmentsModel.fromJson(Map<dynamic, dynamic> json) => LabAppointmentsModel(
    status: json["status"],
    message: json["message"],
    data: List<LabAppointmentsDataModel>.from(json["data"].map((x) => LabAppointmentsDataModel.fromJson(x))),
    extra: LabAppointmentsExtraModel.fromJson(json["extra"]),
  );
}

class LabAppointmentsDataModel {
  LabAppointmentsDataModel({
    this.time,
    this.time24,
    this.isUsed,
  });

  dynamic time24;
  dynamic time;
  dynamic isUsed;

  factory LabAppointmentsDataModel.fromJson(Map<dynamic, dynamic> json) => LabAppointmentsDataModel(
    time: json["time"],
    time24: json["time24"],
    isUsed: json["isUsed"],
  );
}

class LabAppointmentsExtraModel {
  LabAppointmentsExtraModel({
    this.date,
});

  dynamic date;
  factory LabAppointmentsExtraModel.fromJson(Map<dynamic, dynamic> json) => LabAppointmentsExtraModel(
    date: json["date"],
  );

}
