import 'dart:convert';
import 'dart:io';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/onboarding_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/create_token_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/reset_password_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/user_resource_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/verify_model.dart';
import 'package:dar_elteb/models/patient_models/cart_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/branch_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/carousel_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/city_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/country_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/relations_model.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_appointments_model.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_reservation_model.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_result_model.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_appointment_model.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_reservation_model.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_result_model.dart';
import 'package:dar_elteb/models/patient_models/patient_tech_request_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/address_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/families_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/medical-inquiries.dart';
import 'package:dar_elteb/models/patient_models/profile_models/notifications_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/terms_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/categories_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/offers_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/tests_model.dart';
import 'package:dar_elteb/screens/intro_screens/startup/onboarding_screen.dart';
import 'package:dar_elteb/screens/main_screens/home_screen.dart';
import 'package:dar_elteb/screens/main_screens/profile/profile_screen.dart';
import 'package:dar_elteb/screens/main_screens/reserved/reserved_screen.dart';
import 'package:dar_elteb/screens/main_screens/results/results_screen.dart';
import 'package:dar_elteb/screens/main_screens/tests/tests_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/shared/network/remote/end_points.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppStates());

  static AppCubit get(context) => BlocProvider.of(context);

  UserResourceModel? userResourceModel;
  CountryModel? countryModel;
  OnBoardingModel? onBoardingModel;
  CityModel? cityModel;
  BranchModel? branchModel;
  SuccessModel? successModel;
  CarouselModel? carouselModel;
  RelationsModel? relationsModel;
  CreateTokenModel? createTokenModel;
  ResetPasswordModel? resetPasswordModel;
  TestsModel? testsModel;
  CategoriesModel? categoriesModel;
  OffersModel? offersModel;
  TermsModel? termsModel;
  FamiliesModel? familiesModel;
  MedicalInquiriesModel? medicalInquiriesModel;
  LabAppointmentsModel? labAppointmentsModel;
  HomeAppointmentsModel? homeAppointmentsModel;
  LabReservationsModel? labReservationsModel;
  HomeReservationsModel? homeReservationsModel;
  LabResultsModel? labResultsModel;
  HomeResultsModel? homeResultsModel;
  AddressModel? addressModel;
  NotificationsModel? notificationsModel;
  PatientTechnicalSupportModel? patientTechnicalSupportModel;
  CartModel? cartModel;
  GeneralModel? generalModel;
  BannerModel? bannerModel;

  List<BranchesDataModel>? branchNames = [];
  List<String> branchName = [];

  List<AddressDataModel>? addressNames = [];
  List<String> addressName = [];

  List<RelationsDataModel>? relationsNames = [];
  List<String> relationsName = [];

  List<FamiliesDataModel>? familiesNames = [];
  List<String> familiesName = [];

  List<String> addressTitle = [
    LocaleKeys.BtnAtHome.tr(),
  ];

  int? branchIdList;

  int? relationIdList;

  int? addressIdList;

  int? branchIdForReservationList;

  void selectAddressId({required String address}) {
    for (int i = 0; i < addressNames!.length; i++) {
      if (addressNames![i].address == address) {
        addressIdList = addressNames![i].id;
      }
    }
  }

  void selectBranch({required String name}) {
    for (int i = 0; i < branchNames!.length; i++) {
      if (branchNames![i].title == name) {
        branchIdList = branchNames![i].id;
        getOffers(branchId: branchIdList!);
      }
    }
  }

  void selectBranchForReservation({required String name}) {
    for (int i = 0; i < branchNames!.length; i++) {
      if (branchNames![i].title == name) {
        branchIdList = branchNames![i].id;
      }
    }
  }

  void selectRelationId({required String relationName}) {
    for (int i = 0; i < relationsNames!.length; i++) {
      if (relationsNames![i].title == relationName) {
        relationIdList = relationsNames![i].id;
      }
    }
  }

  Future register({
    required String name,
    required String mobile,
    required String phoneCode,
    required String nationalID,
    required String password,
    required String deviceTokenLogin,
  }) async {
    var formData = json.encode({
      'name': name,
      'phone': mobile,
      'phoneCode': '+$phoneCode',
      'password': password,
      'nationalId': nationalID,
      'deviceToken': deviceTokenLogin,
    });
    try {
      emit(AppRegisterLoadingState());
      Dio dio = Dio();
      var response = await dio.post(
        registerURL,
        data: formData,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        print('responseJson : $responseJson');
        print('formData : $formData');
      }
      userResourceModel = UserResourceModel.fromJson(responseJson);
      emit(AppRegisterSuccessState(userResourceModel!));
    } catch (error) {
      if (kDebugMode) {
        // print('error : $error');
      }
      emit(AppRegisterErrorState(error.toString()));
    }
  }

  Future login({
    required String mobile,
    required String phoneCode,
    required String password,
    required String deviceTokenLogin,
  }) async {
    var formData = {
      'phone': mobile,
      'phoneCode': '+$phoneCode',
      'password': password,
      'deviceToken': deviceTokenLogin,
    };
    try {
      emit(AppLoginLoadingState());
      Dio dio = Dio();
      var response = await dio.post(
        loginURL,
        data: formData,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('formData : ${formData.entries}');
        // print('convertedResponse : $convertedResponse');
        // print('responseJson : $responseJson');
      }
      userResourceModel = UserResourceModel.fromJson(responseJson);
      emit(AppLoginSuccessState(userResourceModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppLoginErrorState(error.toString()));
    }
  }

  Future completeProfile({
    required int countryId,
    required int cityId,
    required int branchId,
    required String gender,
  }) async {
    var formData = {
      'countryId': countryId,
      'cityId': cityId,
      'branchId': branchId,
      'gender': gender,
    };
    try {
      emit(AppCompleteProfileLoadingState());
      Dio dio = Dio();
      var response = await dio.post(
        completeProfileURL,
        data: formData,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('headers: ${formData.entries}');
        // print('response: $response');
        // print('responseJsonB: $responseJsonB');
        // print('convertedResponse: $convertedResponse');
        // print('responseJson: $responseJson');
      }
      userResourceModel = UserResourceModel.fromJson(responseJson);
      CacheHelper.saveData(key: 'extraCountryId', value: countryId);
      CacheHelper.saveData(key: 'extraCityId', value: cityId);
      CacheHelper.saveData(key: 'extraBranchId', value: branchId);
      if (kDebugMode) {
        // print('userResourceModel : ${userResourceModel?.extra?.token}');
      }
      emit(AppCompleteProfileSuccessState(userResourceModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppCompleteProfileErrorState(error.toString()));
    }
  }

  Future changeLocation({
    required int countryId,
    required int cityId,
    required int branchId,
  }) async {
    var formData = {
      'countryId': countryId,
      'cityId': cityId,
      'branchId': branchId,
    };
    try {
      emit(AppChangeLocationLoadingState());
      Dio dio = Dio();
      var response = await dio.post(
        changeLocationURL,
        data: formData,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      if (kDebugMode) {
        // print('headers: ${formData.entries}');
        // print('response: $response');
        // print('responseJsonB: $responseJsonB');
        // print('convertedResponse: $convertedResponse');
        // print('responseJson: $responseJson');
      }
      // userResourceModel = UserResourceModel.fromJson(responseJson);
      CacheHelper.saveData(key: 'extraCountryId', value: countryId);
      CacheHelper.saveData(key: 'extraCityId', value: cityId);
      CacheHelper.saveData(key: 'extraBranchId', value: branchId);

      emit(AppChangeLocationSuccessState(successModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppChangeLocationErrorState(error.toString()));
    }
  }

  saveExtraLocation({
    required int extraCountryId1,
    required int extraCityId1,
    required int extraBranchId1,
    required int extraBranchIndex1,
    required String extraBranchTitle1,
  }) async {
    (await SharedPreferences.getInstance())
        .setInt('extraCountryId', extraCountryId1);
    (await SharedPreferences.getInstance()).setInt('extraCityId', extraCityId1);
    (await SharedPreferences.getInstance())
        .setInt('extraBranchId', extraBranchId1);
    (await SharedPreferences.getInstance())
        .setString('extraBranchTitle', extraBranchTitle1);
    (await SharedPreferences.getInstance())
        .setInt('extraBranchIndex', extraBranchIndex1);
    extraCountryId = extraCountryId1;
    extraCityId = extraCityId1;
    extraBranchId = extraBranchId1;
    extraBranchTitle = extraBranchTitle1;
    extraBranchIndex = extraBranchIndex1;
  }

  Future getUserRequest() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Accept-Language': sharedLanguage,
        'Authorization': 'Bearer $token',
      };
      emit(AppGetTechRequestLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        patientTechnicalRequestsURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      patientTechnicalSupportModel =
          PatientTechnicalSupportModel.fromJson(responseJson);
      emit(AppGetTechRequestSuccessState(patientTechnicalSupportModel!));
    } catch (error) {
      emit(AppGetTechRequestErrorState(error.toString()));
    }
  }

  Future getCart() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Accept-Language': sharedLanguage,
        'Authorization': 'Bearer $token',
      };
      emit(AppGetCartLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        cartURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      cartModel = CartModel.fromJson(responseJson);
      emit(AppGetCartSuccessState(cartModel!));
    } catch (error) {
      emit(AppGetCartErrorState(error.toString()));
    }
  }

  Future deleteCart({
    required var cartId,
  }) async {
    emit(AppDeleteCartLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.delete(
        '$cartURL/$cartId/delete',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      getCart();
      emit(AppDeleteCartSuccessState(successModel!));
    } catch (error) {
      emit(AppDeleteCartErrorState(error.toString()));
    }
  }

  Future cancelTechRequest({
    int? technicalRequestId,
  }) async {
    emit(AppCancelTechRequestsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        '$patientTechnicalRequestsURL/$technicalRequestId/cancel',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppCancelTechRequestsSuccessState(successModel!));
    } catch (error) {
      emit(AppCancelTechRequestsErrorState(error.toString()));
    }
  }

  Future getProfile() async {
    try {
      emit(AppGetProfileLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        getProfileURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      userResourceModel = UserResourceModel.fromJson(responseJson);
      if (kDebugMode) {
        print('userResourceModel : ${userResourceModel?.data?.profile}');
      }
      emit(AppGetProfileSuccessState(userResourceModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetProfileErrorState(error.toString()));
    }
  }

  Future getNotifications() async {
    try {
      emit(AppGetNotificationsLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        getNotificationsURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      notificationsModel = NotificationsModel.fromJson(responseJson);
      emit(AppGetNotificationsSuccessState(notificationsModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetNotificationsErrorState(error.toString()));
    }
  }

  Future notificationSeen() async {
    var headers = {
      'Accept': 'application/json',
      'lang': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      emit(AppSeenNotificationsLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        notificationSeenURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      print(responseJson);
      successModel = SuccessModel.fromJson(responseJson);
      getNotifications();
      emit(AppSeenNotificationsSuccessState(successModel!));
    } catch (e) {
      emit(AppSeenNotificationsErrorState(e.toString()));
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future deleteNotifications({
    String? notificationId,
  }) async {
    emit(AppDeleteNotificationsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'lang': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    String url;
    if (notificationId == null) {
      url = '$getNotificationsURL/delete-all';
    } else {
      url = '$getNotificationsURL/$notificationId/delete';
    }
    try {
      Dio dio = Dio();
      var response = await dio.delete(
        url,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      getNotifications();
      emit(AppDeleteNotificationsSuccessState(successModel!));
    } catch (error) {
      if (kDebugMode) {
        print('error ${error.toString()}');
      }
      emit(AppDeleteNotificationsErrorState(error.toString()));
    }
  }

  File? memberImage;

  File? editMemberImage;

  Future getFamilies() async {
    try {
      emit(AppGetFamiliesLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        familiesURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
      }
      familiesModel = FamiliesModel.fromJson(responseJson);
      familiesName = [];
      familiesNames = familiesModel?.data;
      for (var i = 0; i < familiesNames!.length; i++) {
        familiesName.add(
            '${familiesNames?[i].name} ( ${familiesNames![i].relation!.title} )');
      }
      if (kDebugMode) {
        // print('familiesModel : ${familiesModel?.data?.first.profile}');
      }
      emit(AppGetFamiliesSuccessState(familiesModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetFamiliesErrorState(error.toString()));
    }
  }

  Future getBanner() async {
    try {
      emit(AppGetBannerLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        bannerURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      bannerModel = BannerModel.fromJson(responseJson);
      print('bannerModel : $responseJson');
      emit(AppGetBannerSuccessState(bannerModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetBannerErrorState(error.toString()));
    }
  }

  Future getGeneral() async {
    try {
      emit(AppGetGeneralLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        generalURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      generalModel = GeneralModel.fromJson(responseJson);
      emit(AppGetGeneralSuccessState(generalModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetGeneralErrorState(error.toString()));
    }
  }

  Future getAddress() async {
    try {
      emit(AppGetAddressLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        addressURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
      }
      addressModel = AddressModel.fromJson(responseJson);
      addressName = [];
      addressNames = addressModel?.data;
      for (var i = 0; i < addressNames!.length; i++) {
        addressName.add(addressNames?[i].title);
      }
      emit(AppGetAddressSuccessState(addressModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetAddressErrorState(error.toString()));
    }
  }

  Future deleteAddress({
    required var addressId,
  }) async {
    emit(AppDeleteAddressLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.delete(
        '$addressURL/$addressId/delete',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      getAddress();
      emit(AppDeleteAddressSuccessState(successModel!));
    } catch (error) {
      emit(AppDeleteAddressErrorState(error.toString()));
    }
  }

  Future createAddress({
    required var latitude,
    required var longitude,
    required String address,
    required String title,
    String? specialMark,
    String? floorNumber,
    String? buildingNumber,
  }) async {
    emit(AppCreateAddressLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'specialMark': specialMark,
      'floorNumber': floorNumber,
      'buildingNumber': buildingNumber,
      'title': title,
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        createAddressURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('AppCreateAddressSuccessState : $responseJson');
      }
      successModel = SuccessModel.fromJson(responseJson);
      getAddress();
      emit(AppCreateAddressSuccessState(successModel!));
    } catch (error) {
      emit(AppCreateAddressErrorState(error.toString()));
    }
  }

  Future selectAddress({
    required int addressId,
  }) async {
    emit(AppSelectAddressLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        '$addressURL/$addressId/select',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      extraAddressId = addressId;
      getAddress();
      emit(AppSelectAddressSuccessState(successModel!));
    } catch (error) {
      emit(AppSelectAddressErrorState(error.toString()));
    }
  }

  Future cancelLabReservations({
    int? reservationId,
  }) async {
    emit(AppCancelLabReservationLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$getLabReservationsURL/$reservationId/cancel',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppCancelLabReservationSuccessState(successModel!));
    } catch (error) {
      emit(AppCancelLabReservationErrorState(error.toString()));
    }
  }

  Future cancelHomeReservations({
    int? reservationId,
  }) async {
    emit(AppCancelHomeReservationLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$getHomeReservationsURL/$reservationId/cancel',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);

      emit(AppCancelHomeReservationSuccessState(successModel!));
    } catch (error) {
      emit(AppCancelHomeReservationErrorState(error.toString()));
    }
  }

  Future<void> getMemberImage() async {
    try {
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        memberImage = File(pickedImage.path);
        if (kDebugMode) {
          // print('memberImage : $memberImage');
        }
        memberImage = await compressImage(path: pickedImage.path, quality: 35);
        emit(AppProfileImagePickedSuccessState());
      } else {
        if (kDebugMode) {
          // print('no image selected');
          // print(memberImage);
        }
        emit(AppProfileImagePickedErrorState());
      }
    } catch (e) {
      //
    }
  }

  Future<void> getEditMemberImage() async {
    try {
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        editMemberImage = File(pickedImage.path);
        editMemberImage =
            await compressImage(path: pickedImage.path, quality: 35);
        emit(AppProfileImagePickedSuccessState());
      } else {
        emit(AppProfileImagePickedErrorState());
      }
    } catch (e) {
      //
    }
  }

  Future createMember({
    required int relationId,
    required String name,
    required String phone,
    required String birthday,
    required String gender,
    required String profile,
    required String phoneCode,
  }) async {
    emit(AppCreateMemberLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = FormData.fromMap(
      {
        'relationId': relationId,
        'name': name,
        'phone': phone,
        'phoneCode': phoneCode,
        'birthday': birthday,
        'gender': gender,
        if (memberImage != null)
          'profile': await MultipartFile.fromFile(
            memberImage!.path,
            filename: profile,
          ),
      },
    );
    try {
      Dio dio = Dio();
      var response = await dio.post(
        createMemberURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
        // print('formData : ${formData.fields}');
      }
      successModel = SuccessModel.fromJson(responseJson);
      getFamilies();
      emit(AppCreateMemberSuccessState(successModel!));
    } catch (error) {
      emit(AppCreateMemberErrorState(error.toString()));
    }
  }

  Future createInquiry({
    required String message,
    String? file,
  }) async {
    emit(AppCreateInquiryLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = FormData.fromMap(
      {
        'message': message,
        if (inquiryImage != null)
          'file': await MultipartFile.fromFile(
            inquiryImage!.path,
            filename: file,
          ),
      },
    );
    try {
      Dio dio = Dio();
      var response = await dio.post(
        createMedicalInquiriesURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
        // print('createMedicalInquiriesURL : $createMedicalInquiriesURL');
        // print('formData : ${formData.fields}');
      }
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppCreateInquirySuccessState(successModel!));
    } catch (error) {
      emit(AppCreateInquiryErrorState(error.toString()));
    }
  }

  Future deleteInquiry({
    required var inquiryId,
  }) async {
    emit(AppDeleteInquiryLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.delete(
        '$medicalInquiriesURL/$inquiryId/delete',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      getMedicalInquiries();
      emit(AppDeleteInquirySuccessState(successModel!));
    } catch (error) {
      emit(AppDeleteInquiryErrorState(error.toString()));
    }
  }

  Future editMember({
    required String name,
    required String phone,
    required String phoneCode,
    required String profile,
    required var memberId,
  }) async {
    emit(AppEditMemberLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = FormData.fromMap(
      {
        'name': name,
        'phone': phone,
        'phoneCode': phoneCode,
        if (editMemberImage != null)
          'profile': await MultipartFile.fromFile(
            editMemberImage!.path,
            filename: profile,
          ),
      },
    );
    try {
      Dio dio = Dio();
      var response = await dio.post(
        '$familiesURL/$memberId/edit',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
        // print('formData : ${formData.fields}');
      }
      successModel = SuccessModel.fromJson(responseJson);
      getFamilies();
      emit(AppEditMemberSuccessState(successModel!));
    } catch (error) {
      emit(AppEditMemberErrorState(error.toString()));
    }
  }

  Future deleteMember({
    required var memberId,
  }) async {
    emit(AppDeleteMemberLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.delete(
        '$familiesURL/$memberId/delete',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      getFamilies();
      emit(AppDeleteMemberSuccessState(successModel!));
    } catch (error) {
      emit(AppDeleteMemberErrorState(error.toString()));
    }
  }

  Future changeNumber({
    required String phone,
    required String phoneCode,
  }) async {
    emit(AppChangeNumberLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = {
      'phone': phone,
      'phoneCode': '+$phoneCode',
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        changePhoneURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);

      successModel = SuccessModel.fromJson(responseJson);
      if (kDebugMode) {
        print('responseJson : $responseJson');
        print('formData : ${formData.entries}');
      }
      getProfile();
      emit(AppChangeNumberSuccessState(successModel!));
    } catch (error) {
      emit(AppChangeNumberErrorState(error.toString()));
    }
  }

  Future editProfile({
    required String name,
    required String email,
    required String gender,
    required String birthday,
    required String profile,
  }) async {
    emit(AppEditProfileLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = FormData.fromMap(
      {
        'name': name,
        'email': email,
        'gender': gender,
        'birthday': birthday,
        if (profileImage != null)
          'profile': await MultipartFile.fromFile(
            profileImage!.path,
            filename: profile,
          ),
      },
    );
    try {
      Dio dio = Dio();
      var response = await dio.post(
        editProfileURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
        // print('formData : ${formData.fields}');
      }
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppEditProfileSuccessState(successModel!));
    } catch (error) {
      emit(AppEditProfileErrorState(error.toString()));
    }
  }

  Future getTerms() async {
    try {
      emit(AppGetTermsLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        getTermsPrivacyURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      print(responseJson);
      termsModel = TermsModel.fromJson(responseJson);
      emit(AppGetTermsSuccessState(termsModel!));
    } catch (error) {
      emit(AppGetTermsErrorState(error.toString()));
    }
  }

  Future createToken({
    required String mobile,
    required String phoneCode,
  }) async {
    emit(AppCreateTokenLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
    };
    var formData = {
      'phone': mobile,
      'phoneCode': '+$phoneCode',
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        createTokenURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      // print('createTokenModel : $responseJson');
      createTokenModel = CreateTokenModel.fromJson(responseJson);
      emit(AppCreateTokenSuccessState(createTokenModel!));
    } catch (error) {
      emit(AppCreateTokenErrorState(error.toString()));
    }
  }

  Future addToCart({
    int? testId,
    int? offerId,
  }) async {
    emit(AppAddToCartLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = FormData.fromMap({
      if (offerId != null) 'offerId[]': offerId,
      if (testId != null) 'testId[]': testId,
    });
    try {
      Dio dio = Dio();
      var response = await dio.post(
        createCartURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);

      successModel = SuccessModel.fromJson(responseJson);
      getCart();
      emit(AppAddToCartSuccessState(successModel!));
    } catch (error) {
      emit(AppAddToCartErrorState(error.toString()));
    }
  }

  Future resetPassword({
    required String newPassword,
    required String? resetToken,
  }) async {
    emit(AppResetPasswordLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
    };
    var formData = {
      'newPassword': newPassword,
      'resetToken': resetToken,
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        resetPasswordURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      resetPasswordModel = ResetPasswordModel.fromJson(responseJson);
      if (kDebugMode) {
        print('headers.entries : ${headers.entries}');
        print('formData.entries : ${formData.entries}');
        print('responseJson : $responseJson');
        print('resetPasswordModel : ${resetPasswordModel!.data}');
      }
      emit(AppResetPasswordSuccessState(resetPasswordModel!));
    } catch (error) {
      emit(AppResetPasswordErrorState(error.toString()));
    }
  }

  Future changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(AppChangePasswordLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        changePasswordURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
      }
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppChangePasswordSuccessState(successModel!));
    } catch (error) {
      emit(AppChangePasswordErrorState(error.toString()));
    }
  }

  Future getRelations() async {
    emit(AppGetRelationsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        relationsURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      relationsModel = RelationsModel.fromJson(responseJson);
      relationsNames = relationsModel?.data;
      for (var i = 0; i < relationsNames!.length; i++) {
        relationsName.add(relationsNames?[i].title);
      }
      emit(AppGetRelationsSuccessState(relationsModel!));
    } catch (error) {
      emit(AppGetRelationsErrorState(error.toString()));
    }
  }

  Future getCountry() async {
    emit(AppGetCountriesLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        countryURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      countryModel = CountryModel.fromJson(responseJson);
      emit(AppGetCountriesSuccessState(countryModel!));
    } catch (error) {
      emit(AppGetCountriesErrorState(error.toString()));
    }
  }

  Future getOnboarding() async {
    emit(AppGetOnBoardingLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        onboardingURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      onBoardingModel = OnBoardingModel.fromJson(responseJson);
      emit(AppGetOnBoardingSuccessState(onBoardingModel!));
    } catch (error) {
      emit(AppGetOnBoardingErrorState(error.toString()));
    }
  }

  Future getCarouselData() async {
    emit(AppGetCarouselLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        slidersURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('carouselModel : $responseJson');
      }
      carouselModel = CarouselModel.fromJson(responseJson);
      emit(AppGetCarouselSuccessState(carouselModel!));
    } catch (error) {
      emit(AppGetCarouselErrorState(error.toString()));
    }
  }

  Future getCity({
    required int countryId,
  }) async {
    emit(AppGetCitiesLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$cityURL?countryId=$countryId',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      cityModel = CityModel.fromJson(responseJson);
      emit(AppGetCitiesSuccessState(cityModel!));
    } catch (error) {
      emit(AppGetCitiesErrorState(error.toString()));
    }
  }

  Future getBranch({
    required int cityID,
  }) async {
    emit(AppGetBranchesLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$branchURL?cityId=$cityID',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      branchModel = null;
      branchModel = BranchModel.fromJson(responseJson);
      branchName = [];
      branchNames = branchModel?.data;
      for (var i = 0; i < branchNames!.length; i++) {
        branchName.add(branchNames?[i].title);
      }
      if (kDebugMode) {
        // print('branchNames!.length : ${branchNames!.length}');
      }
      emit(AppGetBranchesSuccessState(branchModel!));
    } catch (error) {
      emit(AppGetBranchesErrorState(error.toString()));
    }
  }

  Future getLabAppointments({
    required String date,
  }) async {
    emit(AppGetLabAppointmentsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$labAppointmentURL?date=$date',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);

      labAppointmentsModel = null;
      labAppointmentsModel = LabAppointmentsModel.fromJson(responseJson);
      emit(AppGetLabAppointmentsSuccessState(labAppointmentsModel!));
    } catch (error) {
      emit(AppGetLabAppointmentsErrorState(error.toString()));
    }
  }

  Future getHomeAppointments({
    required String date,
  }) async {
    emit(AppGetHomeAppointmentsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$homeAppointmentURL?date=$date',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      homeAppointmentsModel = null;
      homeAppointmentsModel = HomeAppointmentsModel.fromJson(responseJson);
      emit(AppGetHomeAppointmentsSuccessState(homeAppointmentsModel!));
    } catch (error) {
      emit(AppGetHomeAppointmentsErrorState(error.toString()));
    }
  }

  Future checkCoupon({
    required String coupon,
  }) async {
    emit(AppCheckCouponLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = {
      'coupon': coupon,
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        labCheckCouponsURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppCheckCouponSuccessState(successModel!));
    } catch (error) {
      emit(AppCheckCouponErrorState(error.toString()));
    }
  }

  Future getInvoices({
    List<int>? testId,
    List<int>? offerId,
  }) async {
    emit(AppGetInvoicesLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = {
      if (offerId != null) 'offerId[]': offerId,
      if (testId != null) 'testId[]': testId,
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        labCheckCouponsURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('AppGetInvoicesSuccessState : $responseJson');
      }
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppGetInvoicesSuccessState(successModel!));
    } catch (error) {
      emit(AppGetInvoicesErrorState(error.toString()));
    }
  }

  Future createLabReservation({
    required String date,
    required String time,
    required int branchId,
    int? familyId,
    String? coupon,
    List<String>? testId,
    List<String>? offerId,
  }) async {
    emit(AppCreateLabReservationLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = FormData.fromMap(
      {
        'date': date,
        'time': time,
        'branchId': branchId,
        if (familyId != null) 'familyId': familyId,
        if (offerId != null) 'offerId[]': offerId,
        if (testId != null) 'testId[]': testId,
        if (coupon != null) 'coupon': coupon,
      },
    );
    try {
      Dio dio = Dio();
      var response = await dio.post(
        labReservationsCreateURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
        // print('formData : ${formData.fields}');
      }
      successModel = SuccessModel.fromJson(responseJson);
      getCart();
      emit(AppCreateLabReservationSuccessState(successModel!));
    } catch (error) {
      emit(AppCreateLabReservationErrorState(error.toString()));
    }
  }

  Future createTechnicalRequests({
    required String date,
    required String time,
    required int? addressId,
  }) async {
    emit(AppCreateTechnicalRequestsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = FormData.fromMap(
      {
        'date': date,
        'time': time,
        'addressId': addressId,
      },
    );
    try {
      Dio dio = Dio();
      var response = await dio.post(
        patientTechnicalRequestsCreateURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('responseJson : $responseJson');
        // print('formData : ${formData.fields}');
        // print(
        //     'patientTechnicalRequestsCreateURL : $patientTechnicalRequestsCreateURL');
      }
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppCreateTechnicalRequestsSuccessState(successModel!));
    } catch (error) {
      emit(AppCreateTechnicalRequestsErrorState(error.toString()));
    }
  }

  Future getLabReservations() async {
    emit(AppGetLabReservationsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        getLabReservationsURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      labReservationsModel = LabReservationsModel.fromJson(responseJson);
      emit(AppGetLabReservationsSuccessState(labReservationsModel!));
    } catch (error) {
      emit(AppGetLabReservationsErrorState(error.toString()));
    }
  }

  Future createHomeReservation({
    required String date,
    required String time,
    required int addressId,
    int? familyId,
    required int branchId,
    String? coupon,
    List<String>? testId,
    List<String>? offerId,
  }) async {
    emit(AppCreateHomeReservationLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    var formData = FormData.fromMap(
      {
        'date': date,
        'time': time,
        'addressId': addressId,
        'branchId': branchId,
        if (offerId != null) 'offerId[]': offerId,
        if (testId != null) 'testId[]': testId,
        if (familyId != null) 'familyId': familyId,
        if (coupon != null) 'coupon': coupon,
      },
    );
    try {
      Dio dio = Dio();
      var response = await dio.post(
        homeReservationCreateURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        print('responseJson : $responseJson');
        print('formData : ${formData.fields}');
      }
      successModel = SuccessModel.fromJson(responseJson);
      getCart();
      emit(AppCreateHomeReservationSuccessState(successModel!));
    } catch (error) {
      emit(AppCreateHomeReservationErrorState(error.toString()));
    }
  }

  Future getHomeReservations() async {
    emit(AppGetHomeReservationsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        getHomeReservationsURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      printWrapped('homeReservationsModel : $responseJson');
      homeReservationsModel = HomeReservationsModel.fromJson(responseJson);
      emit(AppGetHomeReservationsSuccessState(homeReservationsModel!));
    } catch (error) {
      emit(AppGetHomeReservationsErrorState(error.toString()));
    }
  }

  Future getLabResults({
    int? resultId,
  }) async {
    emit(AppGetLabResultsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    String getLabResultUrl;
    if (resultId != null) {
      getLabResultUrl = '$getLabResultsURL?resultId=$resultId';
    } else {
      getLabResultUrl = getLabResultsURL;
    }

    try {
      Dio dio = Dio();
      var response = await dio.get(
        getLabResultUrl,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      print('labResultsModel : $responseJson');
      labResultsModel = LabResultsModel.fromJson(responseJson);
      emit(AppGetLabResultsSuccessState(labResultsModel!));
    } catch (error) {
      emit(AppGetLabResultsErrorState(error.toString()));
    }
  }

  Future getHomeResults({
    int? resultId,
  }) async {
    emit(AppGetHomeResultsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    String getHomeResultUrl;
    if (resultId != null) {
      getHomeResultUrl = '$getHomeResultsURL?resultId=$resultId';
    } else {
      getHomeResultUrl = getHomeResultsURL;
    }
    try {
      Dio dio = Dio();
      var response = await dio.get(
        getHomeResultUrl,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      print('homeResultsModel : $responseJson');
      homeResultsModel = HomeResultsModel.fromJson(responseJson);
      emit(AppGetHomeResultsSuccessState(homeResultsModel!));
    } catch (error) {
      emit(AppGetHomeResultsErrorState(error.toString()));
    }
  }

  Future verify() async {
    emit(AppGetVerifyLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        verificationURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print(responseJson);
        // print(headers.entries);
      }
      (await SharedPreferences.getInstance()).setInt('verified', 1).then((v) {
        successModel = SuccessModel.fromJson(responseJson);
        if (kDebugMode) {
          // print('successModel : ${successModel!.status}');
        }
        emit(AppGetVerifySuccessState(successModel!));
      });
    } catch (error) {
      emit(AppGetVerifyErrorState(error.toString()));
    }
  }

  Future getCategories() async {
    try {
      emit(AppGetCategoriesLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        categoriesURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      categoriesModel = CategoriesModel.fromJson(responseJson);
      emit(AppGetCategoriesSuccessState(categoriesModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetCategoriesErrorState(error.toString()));
    }
  }

  Future getOffers({
    int? branchId,
  }) async {
    String url;
    if (branchId == null) {
      url = offersURL;
    } else {
      url = '$offersURL?branchId=$branchId';
    }
    try {
      emit(AppGetOffersLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      offersModel = OffersModel.fromJson(responseJson);
      emit(AppGetOffersSuccessState(offersModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetOffersErrorState(error.toString()));
    }
  }

  Future getMedicalInquiries() async {
    try {
      emit(AppGetMedicalInquiriesLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        medicalInquiriesURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      if (kDebugMode) {
        // print('before medicalInquiriesModel : $convertedResponse');
      }
      medicalInquiriesModel = MedicalInquiriesModel.fromJson(responseJson);
      emit(AppGetMedicalInquiriesSuccessState(medicalInquiriesModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetMedicalInquiriesErrorState(error.toString()));
    }
  }

  Future getTests({
    int? categoriesId,
    String? search,
  }) async {
    String url;
    if (search == null) {
      if (categoriesId == null) {
        url = testsURL;
      } else {
        url = '$testsURL?categoryId=$categoriesId';
      }
    } else {
      url = '$testsURL?search=$search';
    }
    try {
      emit(AppGetTestsLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        url,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': sharedLanguage,
          },
        ),
      );
      print(url);
      var responseJsonB = response.data;
      var convertedResponse = utf8.decode(responseJsonB);
      var responseJson = json.decode(convertedResponse);
      testsModel = TestsModel.fromJson(responseJson);
      if (kDebugMode) {
        print('testsModel responseJson : $responseJson');
      }
      emit(AppGetTestsSuccessState(testsModel!));
    } catch (error) {
      if (kDebugMode) {
        // print(error);
      }
      emit(AppGetTestsErrorState(error.toString()));
    }
  }

  dataSaving({
    required String extraTokenSave,
    required String extraBranchTitle1,
    required String type,
    required int countryId,
    required int cityId,
    required int branchId,
    required int extraBranchIndex1,
    required int isVerifiedSave,
  }) async {
    (await SharedPreferences.getInstance()).setString('token', extraTokenSave);
    (await SharedPreferences.getInstance()).setString('type', type);
    (await SharedPreferences.getInstance())
        .setString('extraBranchTitle', extraBranchTitle1);
    (await SharedPreferences.getInstance()).setInt('extraCountryId', countryId);
    (await SharedPreferences.getInstance()).setInt('extraCityId', cityId);
    (await SharedPreferences.getInstance()).setInt('extraBranchId', branchId);
    (await SharedPreferences.getInstance()).setInt('verified', isVerifiedSave);
    (await SharedPreferences.getInstance())
        .setInt('extraBranchIndex', extraBranchIndex1);
    token = extraTokenSave;
    verified = isVerifiedSave;
    extraCountryId = countryId;
    extraCityId = cityId;
    extraBranchId = branchId;
    extraBranchTitle = extraBranchTitle1;
    extraBranchIndex = extraBranchIndex1;
  }

  IconData loginSufIcon = Icons.visibility_off;
  bool loginIsPassword = true;

  bool? isVisitor;

  bool isEnglish = isEnglishShared ?? true;

  String? local = sharedLanguage;

  dynamic changeLanguage() {
    isEnglish = !isEnglish;
    local = isEnglish ? local = 'en' : local = 'ar';
    fontFamily = isEnglish ? fontFamily = 'Poppins' : fontFamily = 'Cairo';
    CacheHelper.saveData(key: 'local', value: local);
    sharedLanguage = local;
    changeBottomScreen(0);
  }

  void loginChangePasswordVisibility() {
    loginIsPassword = !loginIsPassword;
    loginSufIcon = loginIsPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppLoginChangePasswordVisibilityState());
  }

  IconData signUpSufIcon = Icons.visibility_off;
  bool signUpIsPassword = true;

  void signUpChangePasswordVisibility() {
    signUpIsPassword = !signUpIsPassword;
    signUpSufIcon = signUpIsPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppSignUpChangePasswordVisibilityState());
  }

  IconData resetSufIcon = Icons.visibility_off;
  bool resetIsPassword = true;

  void resetChangePasswordVisibility() {
    resetIsPassword = !resetIsPassword;
    resetSufIcon = resetIsPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppResetChangePasswordVisibilityState());
  }

  IconData resetConfirmSufIcon = Icons.visibility_off;
  bool resetConfirmIsPassword = true;

  void resetConfirmChangePasswordVisibility() {
    resetConfirmIsPassword = !resetConfirmIsPassword;
    resetConfirmSufIcon =
        resetConfirmIsPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppResetConfirmChangePasswordVisibilityState());
  }

  IconData idNumberSufIcon = Icons.visibility;
  bool idNumberIsPassword = true;

  void idNumberChangeVisibility() {
    idNumberIsPassword = !idNumberIsPassword;
    idNumberSufIcon =
        idNumberIsPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppIdNumberVisibilityState());
  }

  int currentIndex = 0;

  int tapIndex = 0;

  bool fromHome = false;

  List<Widget> bottomScreens = [
    const HomeScreen(),
    const TestsScreen(),
    const ReservedScreen(),
    const ResultsScreen(),
    const ProfileScreen(),
  ];

  Future<void> changeBottomScreen(int index) async {
    if (index == 1) {
      if (fromHome) {
        currentIndex = index;
        tapIndex = 1;
      } else {
        currentIndex = index;
        tapIndex = 0;
      }
    } else {
      fromHome = false;
      currentIndex = index;
    }
    emit(AppChangeBottomNavState());
  }

  int currentCarouselIndex = 0;

  void changeCarouselState(int newIndex) {
    currentCarouselIndex = newIndex;
    emit(AppChangeCarouselState());
  }

  var picker = ImagePicker();
  File? profileImage;

  Future<void> getProfileImage() async {
    try {
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        if (kDebugMode) {
          // print('profileImage : $profileImage');
        }
        profileImage = await compressImage(path: pickedImage.path, quality: 35);

        emit(AppProfileImagePickedSuccessState());
      } else {
        if (kDebugMode) {
          // print('no image selected');
          // print(profileImage);
        }
        emit(AppProfileImagePickedErrorState());
      }
    } catch (e) {
      //
    }
  }

  File? inquiryImage;

  Future<void> getInquiryImage() async {
    try {
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        inquiryImage = File(pickedImage.path);
        if (kDebugMode) {
          // print('inquiryImage : $inquiryImage');
        }
        inquiryImage = await compressImage(path: pickedImage.path, quality: 35);

        emit(AppInquiryImagePickedSuccessState());
      } else {
        if (kDebugMode) {
          // print('no image selected');
          // print(inquiryImage);
        }
        emit(AppInquiryImagePickedErrorState());
      }
    } catch (e) {
      //
    }
  }

  void signOut(context) async {
    CacheHelper.removeData(key: 'token').then((value) {
      token = null;
      currentIndex = 0;
      if (value) {
        navigateAndFinish(
          context,
          OnBoardingScreen(isSignOut: true),
        );
      }
      emit(AppLogoutSuccessState());
    });
  }
}

Future<File> compressImage({required String path, required int quality}) async {
  final newPath =
      p.join((await getTemporaryDirectory()).path, p.extension(path));
  final compressedImage = await FlutterImageCompress.compressAndGetFile(
    path,
    newPath,
    quality: quality,
  );
  return compressedImage!;
}
