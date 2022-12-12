// To parse this JSON data, do
//
//     final homeReservationsModel = homeReservationsModelFromJson(jsondynamic);

import 'dart:convert';

HomeReservationsModel homeReservationsModelFromJson(dynamic str) =>
    HomeReservationsModel.fromJson(json.decode(str));

class HomeReservationsModel {
  HomeReservationsModel({
    this.status,
    this.message,
    this.data,
    this.extra,
    this.errors,
  });

  dynamic status;
  dynamic message;
  List<HomeReservationsDataModel>? data;
  Extra? extra;
  Errors? errors;

  factory HomeReservationsModel.fromJson(Map<dynamic, dynamic> json) =>
      HomeReservationsModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<HomeReservationsDataModel>.from(
                json["data"].map((x) => HomeReservationsDataModel.fromJson(x))),
        extra: json["extra"] == null ? null : Extra.fromJson(json["extra"]),
        errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      );
}

class HomeReservationsDataModel {
  HomeReservationsDataModel({
    this.id,
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
    this.titles,
    this.technical,
  });

  dynamic id;
  dynamic date;
  dynamic time;
  Family? family;
  AddressClass? address;
  Branch? branch;
  Coupon? coupon;
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
  Technical? technical;
  List<String>? titles;

  factory HomeReservationsDataModel.fromJson(Map<dynamic, dynamic> json) =>
      HomeReservationsDataModel(
        id: json["id"] == null ? null : json["id"],
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
        titles: json['titles']  == null ? null : json['titles'].cast<String>(),
        family: json["family"] == null ? null : Family.fromJson(json["family"]),
        address: json["address"] == null
            ? null
            : AddressClass.fromJson(json["address"]),
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
        coupon: json["coupon"] == null ? null : Coupon.fromJson(json["coupon"]),
        price: json["price"] == null ? null : json["price"],
        tax: json["tax"] == null ? null : json["tax"],
        discount: json["discount"] == null ? null : json["discount"],
        total: json["total"] == null ? null : json["total"],
        status: json["status"] == null ? null : json["status"],
        statusEn: json["statusEn"] == null ? null : json["statusEn"],
        rate: json["rate"] == null ? null : json["rate"],
        rateMessage: json["rateMessage"] == null ? null : json["rateMessage"],
        createdAt: json["created_at"] == null
            ? null
            : CreatedAt.fromJson(json["created_at"]),
        tests: json["tests"] == null
            ? null
            : List<Offer>.from(json["tests"].map((x) => Offer.fromJson(x))),
        offers: json["offers"] == null
            ? null
            : List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
        technical: json["technical"] == null
            ? null
            : Technical.fromJson(json["technical"]),
      );
}

class AddressClass {
  AddressClass({
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

  factory AddressClass.fromJson(Map<dynamic, dynamic> json) => AddressClass(
        id: json["id"] == null ? null : json["id"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        address: json["address"] == null ? null : json["address"],
        specialMark: json["special_mark"] == null ? null : json["special_mark"],
        floorNumber: json["floor_number"] == null ? null : json["floor_number"],
        buildingNumber:
            json["building_number"] == null ? null : json["building_number"],
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
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );
}

class Coupon {
  Coupon({
    this.id,
    this.code,
  });

  dynamic id;
  dynamic code;

  factory Coupon.fromJson(Map<dynamic, dynamic> json) => Coupon(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
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
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
      );
}

class Family {
  Family({
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
  dynamic birthday;
  dynamic gender;
  dynamic profile;

  factory Family.fromJson(Map<dynamic, dynamic> json) => Family(
        id: json["id"] == null ? null : json["id"],
        relation:
            json["relation"] == null ? null : Branch.fromJson(json["relation"]),
        name: json["name"] == null ? null : json["name"],
        phoneCode: json["phoneCode"] == null ? null : json["phoneCode"],
        phone: json["phone"] == null ? null : json["phone"],
        birthday: json["birthday"] == null ? null : json["birthday"],
        gender: json["gender"] == null ? null : json["gender"],
        profile: json["profile"] == null ? null : json["profile"],
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
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        price: json["price"] == null ? null : json["price"],
        image: json["image"] == null ? null : json["image"],
        category: json["category"] == null ? null : json["category"],
      );
}

class Technical {
  Technical({
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

  factory Technical.fromJson(Map<dynamic, dynamic> json) => Technical(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        profile: json["profile"] == null ? null : json["profile"],
        phoneCode: json["phoneCode"] == null ? null : json["phoneCode"],
        phone: json["phone"] == null ? null : json["phone"],
      );
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<dynamic, dynamic> json) => Errors();

  Map<dynamic, dynamic> toJson() => {};
}

class Extra {
  Extra({
    this.phone,
    this.pagination,
  });

  dynamic phone;
  Pagination? pagination;

  factory Extra.fromJson(Map<dynamic, dynamic> json) => Extra(
        phone: json["phone"] == null ? null : json["phone"],
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
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
