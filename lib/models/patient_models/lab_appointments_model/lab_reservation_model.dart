class LabReservationsModel {
  bool? status;
  dynamic message;
  List<LabReservationsDateModel>? data;
  Extra? extra;
  Errors? errors;

  LabReservationsModel(
      {this.status, this.message, this.data, this.extra, this.errors});

  LabReservationsModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LabReservationsDateModel>[];
      json['data'].forEach((v) {
        data!.add(new LabReservationsDateModel.fromJson(v));
      });
    }
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    errors =
        json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
  }
}

class LabReservationsDateModel {
  dynamic id;
  dynamic date;
  dynamic time;
  List<Null>? family;
  Branch? branch;
  List<Null>? coupon;
  dynamic price;
  dynamic tax;
  dynamic discount;
  dynamic total;
  dynamic status;
  dynamic statusEn;
  dynamic rate;
  dynamic rateMessage;
  CreatedAt? createdAt;
  List<Tests>? tests;
  List<Offers>? offers;

  LabReservationsDateModel(
      {this.id,
      this.date,
      this.time,
      this.family,
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

  LabReservationsDateModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    // if (json['family'] != null) {
    //   family = <Null>[];
    //   json['family'].forEach((v) {
    //     family!.add(new Null.fromJson(v));
    //   });
    // }
    branch =
        json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
    if (json['coupon'] != null) {
      coupon = <Null>[];
      // json['coupon'].forEach((v) {
      //   coupon!.add(new Null.fromJson(v));
      // });
    }
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

class Branch {
  dynamic id;
  dynamic title;

  Branch({this.id, this.title});

  Branch.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}

class CreatedAt {
  dynamic date;
  dynamic time;

  CreatedAt({this.date, this.time});

  CreatedAt.fromJson(Map<dynamic, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }
}

class Tests {
  dynamic id;
  dynamic title;
  dynamic category;
  dynamic price;
  dynamic image;

  Tests({this.id, this.title, this.category, this.price, this.image});

  Tests.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    price = json['price'];
    image = json['image'];
  }
}

class Offers {
  dynamic id;
  dynamic title;
  dynamic price;
  dynamic image;

  Offers({this.id, this.title, this.price, this.image});

  Offers.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    image = json['image'];
  }
}

class Extra {
  dynamic phone;
  Pagination? pagination;

  Extra({this.phone, this.pagination});

  Extra.fromJson(Map<dynamic, dynamic> json) {
    phone = json['phone'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }
}

class Pagination {
  dynamic total;
  dynamic count;
  dynamic perPage;
  dynamic currentPage;
  dynamic lastPage;

  Pagination(
      {this.total, this.count, this.perPage, this.currentPage, this.lastPage});

  Pagination.fromJson(Map<dynamic, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['perPage'];
    currentPage = json['currentPage'];
    lastPage = json['lastPage'];
  }
}

class Errors {
  Errors();

  Errors.fromJson(Map<dynamic, dynamic> json) {}
}
