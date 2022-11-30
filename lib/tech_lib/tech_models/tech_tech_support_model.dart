class TechUserRequestModel {
  bool? status;
  String? message;
  List<TechUserRequestDataModel>? data;
  Extra? extra;
  Errors? errors;

  TechUserRequestModel(
      {this.status, this.message, this.data, this.extra, this.errors});

  TechUserRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TechUserRequestDataModel>[];
      json['data'].forEach((v) {
        data!.add(TechUserRequestDataModel.fromJson(v));
      });
    }
    extra = json['extra'] != null ? Extra.fromJson(json['extra']) : null;
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class TechUserRequestDataModel {
  int? id;
  List<void>? technical;
  Date? date;
  Address? address;
  String? status;
  String? statusEn;
  String? cancelReason;
  Date? createdAt;

  TechUserRequestDataModel(
      {this.id,
      this.technical,
      this.date,
      this.address,
      this.status,
      this.statusEn,
      this.cancelReason,
      this.createdAt});

  TechUserRequestDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    status = json['status'];
    statusEn = json['statusEn'];
    cancelReason = json['cancel_reason'];
    createdAt =
        json['created_at'] != null ? Date.fromJson(json['created_at']) : null;
  }
}

class Date {
  String? date;
  String? time;

  Date({this.date, this.time});

  Date.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
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

class Extra {
  Pagination? pagination;

  Extra({this.pagination});

  Extra.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
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

class Errors {
  Errors();

  Errors.fromJson(Map<String, dynamic> json);
}

class Data {
  int? id;
  List<void>? technical;
  Date? date;
  Address? address;
  String? status;
  String? statusEn;
  String? cancelReason;
  Date? createdAt;

  Data(
      {this.id,
      this.technical,
      this.date,
      this.address,
      this.status,
      this.statusEn,
      this.cancelReason,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    status = json['status'];
    statusEn = json['statusEn'];
    cancelReason = json['cancel_reason'];
    createdAt =
        json['created_at'] != null ? Date.fromJson(json['created_at']) : null;
  }
}
