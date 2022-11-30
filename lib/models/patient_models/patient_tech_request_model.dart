class PatientTechnicalSupportModel {
  bool? status;
  String? message;
  PatientTechnicalSupportDataModel? data;
  Errors? errors;

  PatientTechnicalSupportModel({this.status, this.message, this.data, this.errors});

  PatientTechnicalSupportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PatientTechnicalSupportDataModel.fromJson(json['data']) : null;
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class PatientTechnicalSupportDataModel {
  int? id;
  List<Null>? technical;
  Date? date;
  Address? address;
  String? status;
  String? statusEn;
  String? cancelReason;
  Date? createdAt;

  PatientTechnicalSupportDataModel({this.id, this.technical, this.date, this.address, this.status, this.statusEn, this.cancelReason, this.createdAt});

  PatientTechnicalSupportDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['technical'] != null) {
      technical = <Null>[];
      // json['technical'].forEach((v) { technical!.add(Null.fromJson(v)); });
    }
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    status = json['status'];
    statusEn = json['statusEn'];
    cancelReason = json['cancel_reason'];
    createdAt = json['created_at'] != null ? Date.fromJson(json['created_at']) : null;
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

  Address({this.id, this.latitude, this.longitude, this.address, this.specialMark, this.floorNumber, this.buildingNumber});

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

class Errors {

  Errors();

Errors.fromJson(Map<String, dynamic> json);
}

class Data {
  int? id;
  List<Null>? technical;
  Date? date;
  Address? address;
  String? status;
  String? statusEn;
  String? cancelReason;
  Date? createdAt;

  Data({this.id, this.technical, this.date, this.address, this.status, this.statusEn, this.cancelReason, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['technical'] != null) {
      technical = <Null>[];
      // json['technical'].forEach((v) { technical!.add(Null.fromJson(v)); });
    }
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    status = json['status'];
    statusEn = json['statusEn'];
    cancelReason = json['cancel_reason'];
    createdAt = json['created_at'] != null ? Date.fromJson(json['created_at']) : null;
  }
}
