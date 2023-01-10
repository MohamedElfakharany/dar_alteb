class TechRequestsModel {
  bool? status;
  String? message;
  List<Data>? data;
  Extra? extra;

  TechRequestsModel({this.status, this.message, this.data, this.extra});

  TechRequestsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
  }
}

class Data {
  int? id;
  Patient? patient;
  Patient? technical;
  String? date;
  String? time;
  Family? family;
  Address? address;
  Relation? branch;
  Coupon? coupon;
  String? price;
  String? tax;
  String? discount;
  String? total;
  String? status;
  String? statusEn;
  String? rate;
  String? rateMessage;
  CreatedAt? createdAt;
  List<Tests>? tests;
  List<Offers>? offers;

  Data(
      {this.id,
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
        this.offers});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patient =
    json['patient'] != null ? new Patient.fromJson(json['patient']) : null;
    technical = json['technical'] != null
        ? new Patient.fromJson(json['technical'])
        : null;
    date = json['date'];
    time = json['time'];
    family =
    json['family'] != null ? new Family.fromJson(json['family']) : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    branch =
    json['branch'] != null ? new Relation.fromJson(json['branch']) : null;
    coupon =
    json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : null;
    price = json['price'];
    tax = json['tax'];
    discount = json['discount'];
    total = json['total'];
    status = json['status'];
    statusEn = json['statusEn'];
    rate = json['rate'];
    rateMessage = json['rateMessage'];
    createdAt = json['created_at'] != null
        ? new CreatedAt.fromJson(json['created_at'])
        : null;
    if (json['tests'] != null) {
      tests = <Tests>[];
      json['tests'].forEach((v) {
        tests!.add(new Tests.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(new Offers.fromJson(v));
      });
    }
  }
}

class Patient {
  String? id;
  String? name;
  String? profile;
  String? phoneCode;
  String? phone;

  Patient({this.id, this.name, this.profile, this.phoneCode, this.phone});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profile = json['profile'];
    phoneCode = json['phoneCode'];
    phone = json['phone'];
  }
}

class Family {
  String? id;
  Relation? relation;
  String? name;
  String? phoneCode;
  String? phone;
  String? birthday;
  String? gender;
  String? profile;

  Family(
      {this.id,
        this.relation,
        this.name,
        this.phoneCode,
        this.phone,
        this.birthday,
        this.gender,
        this.profile});

  Family.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relation = json['relation'] != null
        ? new Relation.fromJson(json['relation'])
        : null;
    name = json['name'];
    phoneCode = json['phoneCode'];
    phone = json['phone'];
    birthday = json['birthday'];
    gender = json['gender'];
    profile = json['profile'];
  }
}

class Relation {
  String? id;
  String? title;

  Relation({this.id, this.title});

  Relation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}

class Address {
  String? id;
  String? latitude;
  String? longitude;
  String? address;
  String? specialMark;
  String? floorNumber;
  String? buildingNumber;

  Address(
      {this.id,
        this.latitude,
        this.longitude,
        this.address,
        this.specialMark,
        this.floorNumber,
        this.buildingNumber});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    specialMark = json['special_mark'];
    floorNumber = json['floor_number'];
    buildingNumber = json['building_number'];
  }
}

class Coupon {
  String? id;
  String? code;

  Coupon({this.id, this.code});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
  }
}

class CreatedAt {
  String? date;
  String? time;

  CreatedAt({this.date, this.time});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }
}

class Tests {
  String? id;
  String? title;
  String? category;
  int? price;
  String? image;
  String? isResult;

  Tests(
      {this.id,
        this.title,
        this.category,
        this.price,
        this.image,
        this.isResult});

  Tests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    price = json['price'];
    image = json['image'];
    isResult = json['isResult'];
  }
}

class Offers {
  String? id;
  String? title;
  int? price;
  String? image;
  String? isResult;

  Offers({this.id, this.title, this.price, this.image, this.isResult});

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    image = json['image'];
    isResult = json['isResult'];
  }
}

class Extra {
  Pagination? pagination;

  Extra({this.pagination});

  Extra.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Pagination(
      {this.total, this.count, this.perPage, this.currentPage, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['perPage'];
    currentPage = json['currentPage'];
    lastPage = json['lastPage'];
  }
}
