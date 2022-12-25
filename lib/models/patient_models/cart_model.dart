class CartModel {
  bool? status;
  dynamic message;
  List<Data>? data;
  Extra? extra;
  Errors? errors;

  CartModel({this.status, this.message, this.data, this.extra, this.errors});

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) { data!.add(Data.fromJson(v)); });
    }
    extra = json['extra'] != null ? Extra.fromJson(json['extra']) : null;
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class Data {
  dynamic cartId;
  dynamic id;
  dynamic type;
  dynamic image;
  dynamic title;
  dynamic price;

  Data({this.cartId, this.id, this.type, this.image, this.title, this.price});

  Data.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    id = json['id'];
    type = json['type'];
    image = json['image'];
    title = json['title'];
    price = json['price'];
  }
}

class Extra {
  dynamic price;
  dynamic tax;
  dynamic taxPrice;
  dynamic total;
  List<dynamic>? tests;
  List<dynamic>? offers;

  Extra({this.price, this.tax, this.taxPrice, this.total, this.tests, this.offers});

  Extra.fromJson(Map<dynamic, dynamic> json) {
    price = json['price'];
    tax = json['tax'];
    taxPrice = json['taxPrice'];
    total = json['total'];
    tests = json['tests'];
    offers = json['offers'];
  }
}

class Errors {


  Errors();

Errors.fromJson(Map<String, dynamic> json);
}
