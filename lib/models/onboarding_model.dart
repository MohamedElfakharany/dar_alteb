class OnBoardingModel {
  dynamic status;
  dynamic message;
  OnBoardingDataModel? data;
  Errors? errors;

  OnBoardingModel({this.status, this.message, this.data, this.errors});

  OnBoardingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? OnBoardingDataModel.fromJson(json['data'])
        : null;
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class OnBoardingDataModel {
  Onboarding1? onboarding1;
  Onboarding1? onboarding2;
  Onboarding1? onboarding3;

  OnBoardingDataModel({this.onboarding1, this.onboarding2, this.onboarding3});

  OnBoardingDataModel.fromJson(Map<String, dynamic> json) {
    onboarding1 = json['onboarding1'] != null
        ? Onboarding1.fromJson(json['onboarding1'])
        : null;
    onboarding2 = json['onboarding2'] != null
        ? Onboarding1.fromJson(json['onboarding2'])
        : null;
    onboarding3 = json['onboarding3'] != null
        ? Onboarding1.fromJson(json['onboarding3'])
        : null;
  }
}

class Onboarding1 {
  dynamic image;
  dynamic title;
  dynamic description;

  Onboarding1({this.image, this.title, this.description});

  Onboarding1.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    description = json['description'];
  }
}

class Errors {
  Errors.fromJson(Map<String, dynamic> json);
}

class GeneralModel {
  dynamic status;
  dynamic message;
  GeneralDataModel? data;
  Errors? errors;

  GeneralModel({this.status, this.message, this.data, this.errors});

  GeneralModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? GeneralDataModel.fromJson(json['data']) : null;
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class GeneralDataModel {
  int? homeReservations;
  int? technicalReservations;

  GeneralDataModel({this.homeReservations, this.technicalReservations});

  GeneralDataModel.fromJson(Map<String, dynamic> json) {
    homeReservations = json['homeReservations'];
    technicalReservations = json['technicalReservations'];
  }
}

class BannerModel {
  dynamic status;
  dynamic message;
  BannerDataModel? data;
  Errors? errors;

  BannerModel({this.status, this.message, this.data, this.errors});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? BannerDataModel.fromJson(json['data']) : null;
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class BannerDataModel {
  int? id;
  dynamic image;
  dynamic title;
  dynamic link;

  BannerDataModel({this.id, this.image, this.title, this.link});

  BannerDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    link = json['link'];
  }
}