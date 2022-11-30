// To parse this JSON data, do
//
//     final techReservationsModel = techReservationsModelFromJson(jsondynamic);

import 'dart:convert';

TechReservationsModel techReservationsModelFromJson(dynamic str) => TechReservationsModel.fromJson(json.decode(str));

class TechReservationsModel {
  TechReservationsModel({
    this.status,
    this.message,
    this.data,
    this.extra,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<TechReservationsDataModel>? data;
  Extra? extra;
  Errors? errors;

  factory TechReservationsModel.fromJson(Map<dynamic, dynamic> json) => TechReservationsModel(
    status: json["status"],
    message: json["message"],
    data: List<TechReservationsDataModel>.from(json["data"].map((x) => TechReservationsDataModel.fromJson(x))),
    extra: Extra.fromJson(json["extra"]),
    errors: Errors.fromJson(json["errors"]),
  );
}

class TechReservationsDataModel {
  TechReservationsDataModel({
    this.id,
    this.patient,
    this.technical,
    this.date,
    this.time,
    this.family,
    this.address,
    this.branch,
    this.coupon,
    this.price,
    this.tax,
    this.discount,
    this.total,
    this.status,
    this.statusEn,
    this.rate,
    this.rateMessage,
    this.createdAt,
    this.tests,
    this.offers,
  });

  dynamic id;
  Patient? patient;
  Patient? technical;
  dynamic date;
  dynamic time;
  dynamic family;
  Address? address;
  Branch? branch;
  List<dynamic>? coupon;
  dynamic price;
  dynamic tax;
  dynamic discount;
  dynamic total;
  dynamic status;
  dynamic statusEn;
  dynamic rate;
  dynamic rateMessage;
  CreatedAt? createdAt;
  List<Offer>? tests;
  List<Offer>? offers;

  factory TechReservationsDataModel.fromJson(Map<dynamic, dynamic> json) => TechReservationsDataModel(
    id: json["id"],
    patient: Patient.fromJson(json["patient"]),
    technical: Patient.fromJson(json["technical"]),
    date: json["date"],
    time: json["time"],
    family: json["family"],
    address: Address.fromJson(json["address"]),
    branch: Branch.fromJson(json["branch"]),
    coupon: List<dynamic>.from(json["coupon"].map((x) => x)),
    price: json["price"],
    tax: json["tax"],
    discount: json["discount"],
    total: json["total"],
    status: json["status"],
    statusEn: json["statusEn"],
    rate: json["rate"],
    rateMessage: json["rateMessage"],
    createdAt: CreatedAt.fromJson(json["created_at"]),
    tests: json["tests"] == null ? null : List<Offer>.from(json["tests"].map((x) => Offer.fromJson(x))),
    offers: json["offers"] == null ? null : List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
  );
}

class Address {
  Address({
    this.id,
    this.latitude,
    this.longitude,
    this.address,
    this.specialMark,
    this.floorNumber,
    this.buildingNumber,
  });

  dynamic id;
  dynamic latitude;
  dynamic longitude;
  dynamic address;
  dynamic specialMark;
  dynamic floorNumber;
  dynamic buildingNumber;

  factory Address.fromJson(Map<dynamic, dynamic> json) => Address(
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    address: json["address"],
    specialMark: json["special_mark"],
    floorNumber: json["floor_number"],
    buildingNumber: json["building_number"],
  );
}

class Branch {
  Branch({
    this.id,
    this.title,
  });

  dynamic id;
  dynamic title;

  factory Branch.fromJson(Map<dynamic, dynamic> json) => Branch(
    id: json["id"],
    title: json["title"],
  );
}

class CreatedAt {
  CreatedAt({
    this.date,
    this.time,
  });

  dynamic date;
  dynamic time;

  factory CreatedAt.fromJson(Map<dynamic, dynamic> json) => CreatedAt(
    date: json["date"],
    time: json["time"],
  );
}

class FamilyClass {
  FamilyClass({
    this.id,
    this.relation,
    this.name,
    this.phoneCode,
    this.phone,
    this.birthday,
    this.gender,
    this.profile,
  });

  dynamic id;
  Branch? relation;
  dynamic name;
  dynamic phoneCode;
  dynamic phone;
  DateTime? birthday;
  dynamic gender;
  dynamic profile;

  factory FamilyClass.fromJson(Map<dynamic, dynamic> json) => FamilyClass(
    id: json["id"],
    relation: Branch.fromJson(json["relation"]),
    name: json["name"],
    phoneCode: json["phoneCode"],
    phone: json["phone"],
    birthday: DateTime.parse(json["birthday"]),
    gender: json["gender"],
    profile: json["profile"],
  );
}

class Offer {
  Offer({
    this.id,
    this.title,
    this.price,
    this.image,
    this.category,
  });

  dynamic id;
  dynamic title;
  dynamic price;
  dynamic image;
  dynamic category;

  factory Offer.fromJson(Map<dynamic, dynamic> json) => Offer(
    id: json["id"],
    title: json["title"],
    price: json["price"],
    image: json["image"],
    category: json["category"] == null ? null : json["category"],
  );
}

class Patient {
  Patient({
    this.id,
    this.name,
    this.profile,
    this.phoneCode,
    this.phone,
  });

  dynamic id;
  dynamic name;
  dynamic profile;
  dynamic phoneCode;
  dynamic phone;

  factory Patient.fromJson(Map<dynamic, dynamic> json) => Patient(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    profile: json["profile"] ?? '',
    phoneCode: json["phoneCode"] ?? '',
    phone: json["phone"] ?? '',
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
