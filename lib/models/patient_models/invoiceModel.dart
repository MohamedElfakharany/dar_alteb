class InvoiceModel {
  bool? status;
  dynamic message;
  InvoiceDataModel? data;

  InvoiceModel({this.status, this.message, this.data});

  InvoiceModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? InvoiceDataModel.fromJson(json['data']) : null;
  }
}

class InvoiceDataModel {
  dynamic price;
  dynamic discount;
  dynamic isPercentage;
  dynamic tax;
  dynamic taxPrice;
  dynamic total;

  InvoiceDataModel(
      {this.price,
        this.discount,
        this.isPercentage,
        this.tax,
        this.taxPrice,
        this.total});

  InvoiceDataModel.fromJson(Map<dynamic, dynamic> json) {
    price = json['price'];
    discount = json['discount'];
    isPercentage = json['isPercentage'];
    tax = json['tax'];
    taxPrice = json['taxPrice'];
    total = json['total'];
  }
}
