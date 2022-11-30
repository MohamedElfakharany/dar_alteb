class MedicalInquiriesModel {
  bool? status;
  dynamic message;
  List<MedicalInquiriesDataModel>? data;
  Extra? extra;
  Errors? errors;

  MedicalInquiriesModel({this.status, this.message, this.data, this.extra, this.errors});

  MedicalInquiriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MedicalInquiriesDataModel>[];
      json['data'].forEach((v) { data!.add(MedicalInquiriesDataModel.fromJson(v)); });
    }
    extra = json['extra'] != null ? Extra.fromJson(json['extra']) : null;
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class MedicalInquiriesDataModel {
  dynamic id;
  dynamic message;
  dynamic file;
  Date? date;
  Answer? answer;

  MedicalInquiriesDataModel({this.id, this.message, this.file, this.date, this.answer});

  MedicalInquiriesDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    file = json['file'];
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    answer = json['answer'] != null ? Answer.fromJson(json['answer']) : null;
  }
}

class Date {
  dynamic date;
  dynamic time;

  Date({this.date, this.time});

  Date.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }
}

class Answer {
  User? user;
  dynamic message;
  dynamic file;
  Date? date;

  Answer({this.user, this.message, this.file, this.date});

  Answer.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
    file = json['file'];
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
  }
}

class User {
  dynamic id;
  dynamic name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class Extra {
  Pagination? pagination;

  Extra({this.pagination});

  Extra.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
}

class Pagination {
  dynamic total;
  dynamic count;
  dynamic perPage;
  dynamic currentPage;
  dynamic lastPage;

  Pagination({this.total, this.count, this.perPage, this.currentPage, this.lastPage});

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
