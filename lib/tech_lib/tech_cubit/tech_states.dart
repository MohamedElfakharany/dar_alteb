import 'package:dar_elteb/models/patient_models/auth_models/verify_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/user_resource_model.dart';
import 'package:dar_elteb/tech_lib/tech_models/requests_model.dart';
import 'package:dar_elteb/tech_lib/tech_models/reservation_model.dart';
import 'package:dar_elteb/tech_lib/tech_models/tech_tech_support_model.dart';

abstract class AppTechStates {}

class InitialAppTechStates extends AppTechStates {}

class AppTechChangePasswordLoadingState extends AppTechStates {}

class AppTechChangePasswordSuccessState extends AppTechStates {
  final SuccessModel successModel;

  AppTechChangePasswordSuccessState(this.successModel);
}

class AppTechChangePasswordErrorState extends AppTechStates {
  final String error;

  AppTechChangePasswordErrorState(this.error);
}

class AppTechChangeBottomNavState extends AppTechStates {}

class AppTechLoginLoadingState extends AppTechStates {}

class AppTechEditProfileLoadingState extends AppTechStates {}

class AppTechEditProfileSuccessState extends AppTechStates {
  final SuccessModel successModel;

  AppTechEditProfileSuccessState(this.successModel);
}

class AppTechEditProfileErrorState extends AppTechStates {
  final String error;

  AppTechEditProfileErrorState(this.error);
}

class AppTechResetChangePasswordVisibilityState extends AppTechStates {}

class AppTechResetConfirmChangePasswordVisibilityState extends AppTechStates {}

class AppTechLoginSuccessState extends AppTechStates {
  final UserResourceModel userResourceModel;

  AppTechLoginSuccessState(this.userResourceModel);
}

class AppTechLoginErrorState extends AppTechStates {
  final String error;

  AppTechLoginErrorState(this.error);
}

class AppTechGetProfileLoadingState extends AppTechStates {}

class AppTechGetProfileSuccessState extends AppTechStates {
  final UserResourceModel userResourceModel;

  AppTechGetProfileSuccessState(this.userResourceModel);
}

class AppTechGetProfileErrorState extends AppTechStates {
  final String error;

  AppTechGetProfileErrorState(this.error);
}

class AppTechProfileImagePickedSuccessState extends AppTechStates {}

class AppTechProfileImagePickedErrorState extends AppTechStates {}


class AppGetTechRequestsLoadingState extends AppTechStates{}

class AppGetTechRequestsSuccessState extends AppTechStates{
  final TechRequestsModel techRequestsModel;
  AppGetTechRequestsSuccessState(this.techRequestsModel);
}

class AppGetTechRequestsErrorState extends AppTechStates{
  final String error;
  AppGetTechRequestsErrorState(this.error);
}

class AppGetTechUserRequestLoadingState extends AppTechStates{}

class AppGetTechUserRequestSuccessState extends AppTechStates{
  final TechUserRequestModel techUserRequestModel;
  AppGetTechUserRequestSuccessState(this.techUserRequestModel);
}

class AppGetTechUserRequestErrorState extends AppTechStates{
  final String error;
  AppGetTechUserRequestErrorState(this.error);
}

class AppGetTechReservationsLoadingState extends AppTechStates{}

class AppGetTechReservationsSuccessState extends AppTechStates{
  final TechReservationsModel techReservationsModel;
  AppGetTechReservationsSuccessState(this.techReservationsModel);
}

class AppGetTechReservationsErrorState extends AppTechStates{
  final String error;
  AppGetTechReservationsErrorState(this.error);
}

class AppAcceptRequestsLoadingState extends AppTechStates{}

class AppAcceptRequestsSuccessState extends AppTechStates{
  final SuccessModel successModel;
  AppAcceptRequestsSuccessState(this.successModel);
}

class AppAcceptRequestsErrorState extends AppTechStates{
  final String error;
  AppAcceptRequestsErrorState(this.error);
}

class AppAcceptTechRequestsLoadingState extends AppTechStates{}

class AppAcceptTechRequestsSuccessState extends AppTechStates{
  final SuccessModel successModel;
  AppAcceptTechRequestsSuccessState(this.successModel);
}

class AppAcceptTechRequestsErrorState extends AppTechStates{
  final String error;
  AppAcceptTechRequestsErrorState(this.error);
}

class AppSamplingRequestsLoadingState extends AppTechStates{}

class AppSamplingRequestsSuccessState extends AppTechStates{
  final SuccessModel successModel;
  AppSamplingRequestsSuccessState(this.successModel);
}

class AppSamplingRequestsErrorState extends AppTechStates{
  final String error;
  AppSamplingRequestsErrorState(this.error);
}

class AppTechLogoutSuccessState extends AppTechStates {}
