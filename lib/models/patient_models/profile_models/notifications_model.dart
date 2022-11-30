// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(dynamic str) => NotificationsModel.fromJson(json.decode(str));

class NotificationsModel {
  NotificationsModel({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<NotificationsDataModel>? data;
  Errors? errors;

  factory NotificationsModel.fromJson(Map<dynamic, dynamic> json) => NotificationsModel(
    status: json["status"],
    message: json["message"],
    data: List<NotificationsDataModel>.from(json["data"].map((x) => NotificationsDataModel.fromJson(x))),
    errors: Errors.fromJson(json["errors"]),
  );
}

class NotificationsDataModel {
  NotificationsDataModel({
    this.id,
    this.body,
    this.date,
  });

  dynamic id;
  dynamic body;
  NotificationsDateModel? date;

  factory NotificationsDataModel.fromJson(Map<dynamic, dynamic> json) => NotificationsDataModel(
    id: json["id"],
    body: json["body"],
    date: NotificationsDateModel.fromJson(json["date"]),
  );
}

class NotificationsDateModel {
  NotificationsDateModel({
    this.date,
    this.time,
  });

  dynamic date;
  dynamic time;

  factory NotificationsDateModel.fromJson(Map<dynamic, dynamic> json) => NotificationsDateModel(
    date: json["date"],
    time: json["time"],
  );

  Map<dynamic, dynamic> toJson() => {
    "date": date,
    "time": time,
  };
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors(
  );

  Map<dynamic, dynamic> toJson() => {
  };
}
