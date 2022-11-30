// To parse this JSON data, do
//
//     final techRequestsModel = techRequestsModelFromJson(jsondynamic);

import 'dart:convert';

TechRequestsModel techRequestsModelFromJson(dynamic str) => TechRequestsModel.fromJson(json.decode(str));

class TechRequestsModel {
  TechRequestsModel({
    this.status,
    this.message,
    this.data,
    this.extra,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<TechRequestsDataModel>? data;
  Extra? extra;
  Errors? errors;

  factory TechRequestsModel.fromJson(Map<dynamic, dynamic> json) => TechRequestsModel(
    status: json["status"],
    message: json["message"],
    data: List<TechRequestsDataModel>.from(json["data"].map((x) => TechRequestsDataModel.fromJson(x))),
    extra: Extra.fromJson(json["extra"]),
    errors: Errors.fromJson(json["errors"]),
  );
}

class TechRequestsDataModel {
  TechRequestsDataModel({
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
  TechRequestsPatientModel? patient;
  List<dynamic>? technical;
  dynamic date;
  dynamic time;
  dynamic family;
  TechRequestsAddressModel? address;
  TechRequestsBranchModel? branch;
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

  factory TechRequestsDataModel.fromJson(Map<dynamic, dynamic> json) => TechRequestsDataModel(
    id: json["id"],
    patient: TechRequestsPatientModel.fromJson(json["patient"]),
    technical: List<dynamic>.from(json["technical"].map((x) => x)),
    date: json["date"],
    time: json["time"],
    family: json["family"],
    address: TechRequestsAddressModel.fromJson(json["address"]),
    branch: TechRequestsBranchModel.fromJson(json["branch"]),
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
    //json["category"] == null ? null : json["category"],
    tests: json["tests"] == null ? null : List<Offer>.from(json["tests"].map((x) => Offer.fromJson(x))),
    offers:  json["offers"] == null ? null : List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
  );
}

class TechRequestsAddressModel {
  TechRequestsAddressModel({
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

  factory TechRequestsAddressModel.fromJson(Map<dynamic, dynamic> json) => TechRequestsAddressModel(
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    address: json["address"],
    specialMark: json["special_mark"],
    floorNumber: json["floor_number"],
    buildingNumber: json["building_number"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "special_mark": specialMark,
    "floor_number": floorNumber,
    "building_number": buildingNumber,
  };
}

class TechRequestsBranchModel {
  TechRequestsBranchModel({
    this.id,
    this.title,
  });

  dynamic id;
  dynamic title;

  factory TechRequestsBranchModel.fromJson(Map<dynamic, dynamic> json) => TechRequestsBranchModel(
    id: json["id"],
    title: json["title"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
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

  Map<dynamic, dynamic> toJson() => {
    "date": date,
    "time": time,
  };
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
  TechRequestsBranchModel? relation;
  dynamic name;
  dynamic phoneCode;
  dynamic phone;
  dynamic birthday;
  dynamic gender;
  dynamic profile;

  factory FamilyClass.fromJson(Map<dynamic, dynamic> json) => FamilyClass(
    id: json["id"],
    relation: TechRequestsBranchModel.fromJson(json["relation"]),
    name: json["name"],
    phoneCode: json["phoneCode"],
    phone: json["phone"],
    birthday: json["birthday"],
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

class TechRequestsPatientModel {
  TechRequestsPatientModel({
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

  factory TechRequestsPatientModel.fromJson(Map<dynamic, dynamic> json) => TechRequestsPatientModel(
    id: json["id"],
    name: json["name"],
    profile: json["profile"],
    phoneCode: json["phoneCode"],
    phone: json["phone"],
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
