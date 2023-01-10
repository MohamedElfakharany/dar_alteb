class LabResultsModel {
  bool? status;
  String? message;
  List<LabResultsDataModel>? data;
  Extra? extra;
  Errors? errors;

  LabResultsModel({this.status, this.message, this.data, this.extra, this.errors});

  LabResultsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LabResultsDataModel>[];
      json['data'].forEach((v) { data!.add(new LabResultsDataModel.fromJson(v)); });
    }
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    errors = json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.extra != null) {
      data['extra'] = this.extra!.toJson();
    }
    if (this.errors != null) {
      data['errors'] = this.errors!.toJson();
    }
    return data;
  }
}

class LabResultsDataModel {
  int? id;
  int? countResult;
  Date? date;
  List<LabResultsDataFileModel>? results;

  LabResultsDataModel({this.id, this.countResult, this.date, this.results});

  LabResultsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countResult = json['countResult'];
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
    if (json['results'] != null) {
      results = <LabResultsDataFileModel>[];
      json['results'].forEach((v) { results!.add(new LabResultsDataFileModel.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countResult'] = this.countResult;
    if (this.date != null) {
      data['date'] = this.date!.toJson();
    }
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}

class LabResultsDataFileModel {
  int? id;
  String? file;
  String? title;
  Date? date;
  String? notes;
  String? isViewed;

  LabResultsDataFileModel({this.id, this.file, this.title, this.date, this.notes, this.isViewed});

  LabResultsDataFileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    title = json['title'];
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
    notes = json['notes'];
    isViewed = json['isViewed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file'] = this.file;
    data['title'] = this.title;
    if (this.date != null) {
      data['date'] = this.date!.toJson();
    }
    data['notes'] = this.notes;
    data['isViewed'] = this.isViewed;
    return data;
  }
}

class Extra {
  Pagination? pagination;

  Extra({this.pagination});

  Extra.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Pagination({this.total, this.count, this.perPage, this.currentPage, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['perPage'];
    currentPage = json['currentPage'];
    lastPage = json['lastPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['count'] = this.count;
    data['perPage'] = this.perPage;
    data['currentPage'] = this.currentPage;
    data['lastPage'] = this.lastPage;
    return data;
  }
}

class Errors {


  Errors();

Errors.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}
