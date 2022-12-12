import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dar_elteb/models/patient_models/auth_models/reset_password_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/verify_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/user_resource_model.dart';
import 'package:dar_elteb/screens/intro_screens/startup/onboarding_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/shared/network/remote/end_points.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';
import 'package:dar_elteb/tech_lib/tech_models/requests_model.dart';
import 'package:dar_elteb/tech_lib/tech_models/reservation_model.dart';
import 'package:dar_elteb/tech_lib/tech_models/tech_tech_support_model.dart';
import 'package:dar_elteb/tech_lib/tech_screens/profile_screens/profile_screen.dart';
import 'package:dar_elteb/tech_lib/tech_screens/tech_home_screen.dart';
import 'package:dar_elteb/tech_lib/tech_screens/tech_requests_screen.dart';
import 'package:dar_elteb/tech_lib/tech_screens/reserved_screens/tech_reserved_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:geocoding/geocoding.dart' as geo;

class AppTechCubit extends Cubit<AppTechStates> {
  AppTechCubit() : super(InitialAppTechStates());

  static AppTechCubit get(context) => BlocProvider.of(context);

  UserResourceModel? userResourceModel;
  SuccessModel? successModel;
  ResetPasswordModel? resetPasswordModel;
  TechRequestsModel? techRequestsModel;
  TechReservationsModel? techReservationsModel;
  List<TechReservationsDataModel>? techReservationsAcceptedModel = [];
  List<TechReservationsDataModel>? techReservationsSamplingModel = [];
  List<TechReservationsDataModel>? techReservationsCanceledModel = [];
  List<TechReservationsDataModel>? techReservationsFinishedModel = [];
  TechUserRequestModel? techUserRequestModel;

  double mLatitude = 0;
  double mLongitude = 0;
  GoogleMapController? controller;
  Location currentLocation = Location();
  final Set<Marker> markers = {};
  geo.Placemark? userAddress;
  String? addressLocation;
  Location location = Location();

  Future _getLocation({double? lat, double? long}) async {
    LocationData pos = await location.getLocation();
    mLatitude = pos.latitude!;
    mLongitude = pos.longitude!;
    lat = mLatitude;
    long = mLongitude;
    var permission = await currentLocation.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await currentLocation.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    } else {
      currentLocation.onLocationChanged.listen((LocationData loc) {
        lat = loc.latitude!;
        long = loc.longitude!;
        controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(loc.latitude ?? lat ?? mLatitude,
                  loc.longitude ?? long ?? mLongitude),
              zoom: 17.0,
            ),
          ),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Home'),
              position: LatLng(loc.latitude ?? lat ?? mLatitude,
                  loc.longitude ?? long ?? mLongitude)),
        );
      });
    }
  }

  Future<void> getAddressBasedOnLocation({double? lat, double? long}) async {
    lat = mLatitude;
    long = mLongitude;
    await _getLocation(lat: lat, long: long).then((value) async {
      var address = await geo.placemarkFromCoordinates(lat!, long!);
      userAddress = address.first;
      controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 17.0,
          ),
        ),
      );
      markers.add(
        Marker(markerId: const MarkerId('Home'), position: LatLng(lat, long)),
      );
      addressLocation =
          '${userAddress?.administrativeArea} ${userAddress?.locality} ${userAddress?.street} ${userAddress?.subThoroughfare}';
    });
  }

  Future getProfile() async {
    try {
      emit(AppTechGetProfileLoadingState());
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
      emit(AppTechGetProfileSuccessState(userResourceModel!));
    } catch (error) {
      emit(AppTechGetProfileErrorState(error.toString()));
    }
  }

  Future changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(AppTechChangePasswordLoadingState());
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
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppTechChangePasswordSuccessState(successModel!));
    } catch (error) {
      emit(AppTechChangePasswordErrorState(error.toString()));
    }
  }

  Future editProfile({
    required String name,
    required String email,
    required String gender,
    required String birthday,
    required String profile,
  }) async {
    emit(AppTechEditProfileLoadingState());
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
      successModel = SuccessModel.fromJson(responseJson);
      emit(AppTechEditProfileSuccessState(successModel!));
    } catch (error) {
      emit(AppTechEditProfileErrorState(error.toString()));
    }
  }

  Future getRequests() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Accept-Language': sharedLanguage,
        'Authorization': 'Bearer $token',
      };
      emit(AppGetTechRequestsLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        technicalRequestsURL,
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
      techRequestsModel = TechRequestsModel.fromJson(responseJson);
      emit(AppGetTechRequestsSuccessState(techRequestsModel!));
    } catch (error) {
      emit(AppGetTechRequestsErrorState(error.toString()));
    }
  }

  Future getUserRequest() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Accept-Language': sharedLanguage,
        'Authorization': 'Bearer $token',
      };
      emit(AppGetTechUserRequestLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        userRequestURL,
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
      techUserRequestModel = TechUserRequestModel.fromJson(responseJson);
      emit(AppGetTechUserRequestSuccessState(techUserRequestModel!));
    } catch (error) {
      emit(AppGetTechUserRequestErrorState(error.toString()));
    }
  }

  Future getReservations({
    String? dateFrom,
    String? dateTo,
  }) async {
    String url;
    if (dateFrom == null){
      url = technicalReservationsURL;
    }else {
      url = '$technicalReservationsURL?dateFrom=$dateFrom&dateTo=$dateTo';
    }
    try {
      var headers = {
        'Accept': 'application/json',
        'Accept-Language': sharedLanguage,
        'Authorization': 'Bearer $token',
      };
      emit(AppGetTechReservationsLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
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
      techReservationsModel = TechReservationsModel.fromJson(responseJson);
      techReservationsAcceptedModel = [];
      techReservationsSamplingModel = [];
      techReservationsFinishedModel = [];
      techReservationsCanceledModel = [];
      for (var i = 0; i < techReservationsModel!.data!.length; i++) {
        if (techReservationsModel!.data?[i].statusEn == 'Accepted') {
          techReservationsAcceptedModel!.add(techReservationsModel!.data![i]);
        } else if (techReservationsModel?.data?[i].statusEn == 'Sampling') {
          techReservationsSamplingModel!.add(techReservationsModel!.data![i]);
        } else if (techReservationsModel?.data?[i].statusEn == 'Finished') {
          techReservationsFinishedModel!.add(techReservationsModel!.data![i]);
        } else {
          techReservationsCanceledModel?.add(techReservationsModel!.data![i]);
        }
      }
      print('AppGetTechReservationsSuccessState : $responseJson');
      emit(AppGetTechReservationsSuccessState(techReservationsModel!));
    } catch (error) {
      emit(AppGetTechReservationsErrorState(error.toString()));
    }
  }

  Future acceptRequest({
    required var requestId,
  }) async {
    emit(AppAcceptRequestsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$technicalRequestsURL/$requestId/accepted',
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
      getRequests();
      getReservations();
      emit(AppAcceptRequestsSuccessState(successModel!));
    } catch (error) {
      emit(AppAcceptRequestsErrorState(error.toString()));
    }
  }

  Future acceptTechRequest({
    required var techRequest,
  }) async {
    emit(AppAcceptTechRequestsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$userRequestURL/$techRequest/accepted',
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
      getUserRequest();
      emit(AppAcceptTechRequestsSuccessState(successModel!));
    } catch (error) {
      emit(AppAcceptTechRequestsErrorState(error.toString()));
    }
  }

  Future sampling({
    required var requestId,
  }) async {
    emit(AppSamplingRequestsLoadingState());
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': sharedLanguage,
      'Authorization': 'Bearer $token',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        '$technicalReservationsURL/$requestId/sampling',
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
      getReservations();
      emit(AppSamplingRequestsSuccessState(successModel!));
    } catch (error) {
      emit(AppSamplingRequestsErrorState(error.toString()));
    }
  }

  dataSaving({
    required String extraTokenSave,
    required String extraBranchTitle1,
    required int countryId,
    required int cityId,
    required int branchId,
    required int isVerifiedSave,
  }) async {
    (await SharedPreferences.getInstance()).setString('token', extraTokenSave);
    (await SharedPreferences.getInstance())
        .setString('extraBranchTitle', extraBranchTitle1);
    (await SharedPreferences.getInstance()).setInt('extraCountryId', countryId);
    (await SharedPreferences.getInstance()).setInt('extraCityId', cityId);
    (await SharedPreferences.getInstance()).setInt('extraBranchId', branchId);
    (await SharedPreferences.getInstance()).setInt('verified', isVerifiedSave);
    token = extraTokenSave;
    verified = isVerifiedSave;
    extraCountryId = countryId;
    extraCityId = cityId;
    extraBranchId = branchId;
    extraBranchTitle = extraBranchTitle1;
  }

  IconData resetSufIcon = Icons.visibility_off;
  bool resetIsPassword = true;

  void resetChangePasswordVisibility() {
    resetIsPassword = !resetIsPassword;
    resetSufIcon = resetIsPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppTechResetChangePasswordVisibilityState());
  }

  IconData resetConfirmSufIcon = Icons.visibility_off;
  bool resetConfirmIsPassword = true;

  void resetConfirmChangePasswordVisibility() {
    resetConfirmIsPassword = !resetConfirmIsPassword;
    resetConfirmSufIcon =
        resetConfirmIsPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppTechResetConfirmChangePasswordVisibilityState());
  }

  bool? isVisitor;

  bool isEnglish = true;

  String? local = sharedLanguage;

  dynamic changeLanguage() {
    isEnglish = !isEnglish;
    local = isEnglish ? local = 'en' : local = 'ar';
    CacheHelper.saveData(key: 'local', value: local);
    sharedLanguage = local;
    changeBottomScreen(0);
  }

  int currentIndex = 0;

  int tapIndex = 0;

  bool fromHome = false;

  List<Widget> bottomScreens = [
    const TechHomeScreen(),
    const TechRequestsScreen(),
    const TechReservedScreen(),
    const TechProfileScreen(),
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
    emit(AppTechChangeBottomNavState());
  }

  var picker = ImagePicker();
  File? profileImage;

  Future<void> getProfileImage() async {
    try {
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        profileImage = await compressImage(path: pickedImage.path, quality: 35);
        emit(AppTechProfileImagePickedSuccessState());
      } else {
        emit(AppTechProfileImagePickedErrorState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
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
      emit(AppTechLogoutSuccessState());
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
