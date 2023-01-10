import 'package:dar_elteb/models/onboarding_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/create_token_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/reset_password_model.dart';
import 'package:dar_elteb/models/patient_models/cart_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/branch_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/carousel_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/city_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/country_model.dart';
import 'package:dar_elteb/models/patient_models/cores_models/relations_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/verify_model.dart';
import 'package:dar_elteb/models/patient_models/auth_models/user_resource_model.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_appointments_model.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_reservation_model.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_result_model.dart';
import 'package:dar_elteb/models/patient_models/invoiceModel.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_appointment_model.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_reservation_model.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_result_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/address_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/families_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/medical-inquiries.dart';
import 'package:dar_elteb/models/patient_models/profile_models/notifications_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/terms_model.dart';
import 'package:dar_elteb/models/patient_models/patient_tech_request_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/categories_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/offers_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/tests_model.dart';


abstract class AppStates {}

class InitialAppStates extends AppStates{}

class AppLoginChangePasswordVisibilityState extends AppStates{}

class AppSignUpChangePasswordVisibilityState extends AppStates{}

class AppResetChangePasswordVisibilityState extends AppStates{}

class AppResetConfirmChangePasswordVisibilityState extends AppStates{}

class AppIdNumberVisibilityState extends AppStates{}

class AppChangeBottomNavState extends AppStates{}

class AppChangeCarouselState extends AppStates{}

class AppRegisterLoadingState extends AppStates{}

class AppRegisterSuccessState extends AppStates{
  final UserResourceModel userResourceModel;
  AppRegisterSuccessState(this.userResourceModel);
}

class AppRegisterErrorState extends AppStates{
  final String error;
  AppRegisterErrorState(this.error);
}

class AppCreateMemberLoadingState extends AppStates{}

class AppCreateMemberSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCreateMemberSuccessState(this.successModel);
}

class AppCreateMemberErrorState extends AppStates{
  final String error;
  AppCreateMemberErrorState(this.error);
}

class AppCreateLabReservationLoadingState extends AppStates{}

class AppCreateLabReservationSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCreateLabReservationSuccessState(this.successModel);
}

class AppCreateLabReservationErrorState extends AppStates{
  final String error;
  AppCreateLabReservationErrorState(this.error);
}

class AppCancelLabReservationLoadingState extends AppStates{}

class AppCancelLabReservationSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCancelLabReservationSuccessState(this.successModel);
}

class AppCancelLabReservationErrorState extends AppStates{
  final String error;
  AppCancelLabReservationErrorState(this.error);
}

class AppRateTechnicalLoadingState extends AppStates{}

class AppRateTechnicalSuccessState extends AppStates{
  final SuccessModel successModel;
  AppRateTechnicalSuccessState(this.successModel);
}

class AppRateTechnicalErrorState extends AppStates{
  final String error;
  AppRateTechnicalErrorState(this.error);
}

class AppCancelHomeReservationLoadingState extends AppStates{}

class AppCancelHomeReservationSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCancelHomeReservationSuccessState(this.successModel);
}

class AppCancelHomeReservationErrorState extends AppStates{
  final String error;
  AppCancelHomeReservationErrorState(this.error);
}

class AppCancelTechRequestsLoadingState extends AppStates{}

class AppCancelTechRequestsSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCancelTechRequestsSuccessState(this.successModel);
}

class AppCancelTechRequestsErrorState extends AppStates{
  final String error;
  AppCancelTechRequestsErrorState(this.error);
}

class AppCreateTechnicalRequestsLoadingState extends AppStates{}

class AppCreateTechnicalRequestsSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCreateTechnicalRequestsSuccessState(this.successModel);
}

class AppCreateTechnicalRequestsErrorState extends AppStates{
  final String error;
  AppCreateTechnicalRequestsErrorState(this.error);
}

class AppCreateHomeReservationLoadingState extends AppStates{}

class AppCreateHomeReservationSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCreateHomeReservationSuccessState(this.successModel);
}

class AppCreateHomeReservationErrorState extends AppStates{
  final String error;
  AppCreateHomeReservationErrorState(this.error);
}

class AppCreateInquiryLoadingState extends AppStates{}

class AppCreateInquirySuccessState extends AppStates{
  final SuccessModel successModel;
  AppCreateInquirySuccessState(this.successModel);
}

class AppCreateInquiryErrorState extends AppStates{
  final String error;
  AppCreateInquiryErrorState(this.error);
}

class AppLoginLoadingState extends AppStates{}

class AppLoginSuccessState extends AppStates{
  final UserResourceModel userResourceModel;
  AppLoginSuccessState(this.userResourceModel);
}

class AppLoginErrorState extends AppStates{
  final String error;
  AppLoginErrorState(this.error);
}

class AppGetProfileLoadingState extends AppStates{}

class AppGetProfileSuccessState extends AppStates{
  final UserResourceModel userResourceModel;
  AppGetProfileSuccessState(this.userResourceModel);
}

class AppGetProfileErrorState extends AppStates{
  final String error;
  AppGetProfileErrorState(this.error);
}

class AppGetNotificationsLoadingState extends AppStates{}

class AppGetNotificationsSuccessState extends AppStates{
  final NotificationsModel notificationsModel;
  AppGetNotificationsSuccessState(this.notificationsModel);
}

class AppGetNotificationsErrorState extends AppStates{
  final String error;
  AppGetNotificationsErrorState(this.error);
}

class AppSeenNotificationsLoadingState extends AppStates{}

class AppSeenNotificationsSuccessState extends AppStates{
  final SuccessModel successModel;
  AppSeenNotificationsSuccessState(this.successModel);
}

class AppSeenNotificationsErrorState extends AppStates{
  final String error;
  AppSeenNotificationsErrorState(this.error);
}

class AppDeleteNotificationsLoadingState extends AppStates{}

class AppDeleteNotificationsSuccessState extends AppStates{
  final SuccessModel successModel;
  AppDeleteNotificationsSuccessState(this.successModel);
}

class AppDeleteNotificationsErrorState extends AppStates{
  final String error;
  AppDeleteNotificationsErrorState(this.error);
}


class AppGetFamiliesLoadingState extends AppStates{}

class AppGetFamiliesSuccessState extends AppStates{
  final FamiliesModel familiesModel;
  AppGetFamiliesSuccessState(this.familiesModel);
}

class AppGetFamiliesErrorState extends AppStates{
  final String error;
  AppGetFamiliesErrorState(this.error);
}


class AppCompleteProfileLoadingState extends AppStates{}

class AppCompleteProfileSuccessState extends AppStates{
  final UserResourceModel userResourceModel;
  AppCompleteProfileSuccessState(this.userResourceModel);
}

class AppCompleteProfileErrorState extends AppStates{
  final String error;
  AppCompleteProfileErrorState(this.error);
}

class AppChangeLocationLoadingState extends AppStates{}

class AppChangeLocationSuccessState extends AppStates{
  final SuccessModel successModel;
  AppChangeLocationSuccessState(this.successModel);
}

class AppChangeLocationErrorState extends AppStates{
  final String error;
  AppChangeLocationErrorState(this.error);
}

class AppGetTechRequestLoadingState extends AppStates{}

class AppGetTechRequestSuccessState extends AppStates{
  final PatientTechnicalSupportModel patientTechnicalSupportModel;
  AppGetTechRequestSuccessState(this.patientTechnicalSupportModel);
}

class AppGetTechRequestErrorState extends AppStates{
  final String error;
  AppGetTechRequestErrorState(this.error);
}

class AppGetCartLoadingState extends AppStates{}

class AppGetCartSuccessState extends AppStates{
  final CartModel cartModel;
  AppGetCartSuccessState(this.cartModel);
}

class AppGetCartErrorState extends AppStates{
  final String error;
  AppGetCartErrorState(this.error);
}

class AppGetCountriesLoadingState extends AppStates{}

class AppGetCountriesSuccessState extends AppStates{
  final CountryModel countriesModel;
  AppGetCountriesSuccessState(this.countriesModel);
}

class AppGetCountriesErrorState extends AppStates{
  final String error;
  AppGetCountriesErrorState(this.error);
}


class AppGetOnBoardingLoadingState extends AppStates{}

class AppGetOnBoardingSuccessState extends AppStates{
  final OnBoardingModel onBoardingModel;
  AppGetOnBoardingSuccessState(this.onBoardingModel);
}

class AppGetOnBoardingErrorState extends AppStates{
  final String error;
  AppGetOnBoardingErrorState(this.error);
}

class AppGetRelationsLoadingState extends AppStates{}

class AppGetRelationsSuccessState extends AppStates{
  final RelationsModel relationsModel;
  AppGetRelationsSuccessState(this.relationsModel);
}

class AppGetRelationsErrorState extends AppStates{
  final String error;
  AppGetRelationsErrorState(this.error);
}

class AppGetVerifyLoadingState extends AppStates{}

class AppGetVerifySuccessState extends AppStates{
  final SuccessModel successModel;
  AppGetVerifySuccessState(this.successModel);
}

class AppGetVerifyErrorState extends AppStates{
  final String error;
  AppGetVerifyErrorState(this.error);
}

class AppEditProfileLoadingState extends AppStates{}

class AppEditProfileSuccessState extends AppStates{
  final SuccessModel successModel;
  AppEditProfileSuccessState(this.successModel);
}

class AppEditProfileErrorState extends AppStates{
  final String error;
  AppEditProfileErrorState(this.error);
}

class AppEditMemberLoadingState extends AppStates{}

class AppEditMemberSuccessState extends AppStates{
  final SuccessModel successModel;
  AppEditMemberSuccessState(this.successModel);
}

class AppEditMemberErrorState extends AppStates{
  final String error;
  AppEditMemberErrorState(this.error);
}

class AppDeleteMemberLoadingState extends AppStates{}

class AppDeleteMemberSuccessState extends AppStates{
  final SuccessModel successModel;
  AppDeleteMemberSuccessState(this.successModel);
}

class AppDeleteMemberErrorState extends AppStates{
  final String error;
  AppDeleteMemberErrorState(this.error);
}

class AppDeleteInquiryLoadingState extends AppStates{}

class AppDeleteInquirySuccessState extends AppStates{
  final SuccessModel successModel;
  AppDeleteInquirySuccessState(this.successModel);
}

class AppDeleteInquiryErrorState extends AppStates{
  final String error;
  AppDeleteInquiryErrorState(this.error);
}

class AppDeleteAddressLoadingState extends AppStates{}

class AppDeleteAddressSuccessState extends AppStates{
  final SuccessModel successModel;
  AppDeleteAddressSuccessState(this.successModel);
}

class AppDeleteAddressErrorState extends AppStates{
  final String error;
  AppDeleteAddressErrorState(this.error);
}

class AppDeleteCartLoadingState extends AppStates{}

class AppDeleteCartSuccessState extends AppStates{
  final SuccessModel successModel;
  AppDeleteCartSuccessState(this.successModel);
}

class AppDeleteCartErrorState extends AppStates{
  final String error;
  AppDeleteCartErrorState(this.error);
}

class AppCreateAddressLoadingState extends AppStates{}

class AppCreateAddressSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCreateAddressSuccessState(this.successModel);
}

class AppCreateAddressErrorState extends AppStates{
  final String error;
  AppCreateAddressErrorState(this.error);
}

class AppSelectAddressLoadingState extends AppStates{}

class AppSelectAddressSuccessState extends AppStates{
  final SuccessModel successModel;
  AppSelectAddressSuccessState(this.successModel);
}

class AppSelectAddressErrorState extends AppStates{
  final String error;
  AppSelectAddressErrorState(this.error);
}

class AppChangeNumberLoadingState extends AppStates{}

class AppChangeNumberSuccessState extends AppStates{
  final SuccessModel successModel;
  AppChangeNumberSuccessState(this.successModel);
}

class AppChangeNumberErrorState extends AppStates{
  final String error;
  AppChangeNumberErrorState(this.error);
}

class AppCheckCouponLoadingState extends AppStates{}

class AppCheckCouponSuccessState extends AppStates{
  final SuccessModel successModel;
  AppCheckCouponSuccessState(this.successModel);
}

class AppCheckCouponErrorState extends AppStates{
  final String error;
  AppCheckCouponErrorState(this.error);
}

class AppGetInvoicesLoadingState extends AppStates{}

class AppGetInvoicesSuccessState extends AppStates{
  final InvoiceModel invoiceModel;
  AppGetInvoicesSuccessState(this.invoiceModel);
}

class AppGetInvoicesErrorState extends AppStates{
  final String error;
  AppGetInvoicesErrorState(this.error);
}

class AppGetCitiesLoadingState extends AppStates{}

class AppGetCitiesSuccessState extends AppStates{
  final CityModel cityModel;
  AppGetCitiesSuccessState(this.cityModel);
}

class AppGetCitiesErrorState extends AppStates{
  final String error;
  AppGetCitiesErrorState(this.error);
}

class AppGetLabReservationsLoadingState extends AppStates{}

class AppGetLabReservationsSuccessState extends AppStates{
  final LabReservationsModel labReservationsModel;
  AppGetLabReservationsSuccessState(this.labReservationsModel);
}

class AppGetLabReservationsErrorState extends AppStates{
  final String error;
  AppGetLabReservationsErrorState(this.error);
}

class AppGetLabResultsLoadingState extends AppStates{}

class AppGetLabResultsSuccessState extends AppStates{
  final LabResultsModel labResultsModel;
  AppGetLabResultsSuccessState(this.labResultsModel);
}

class AppGetLabResultsErrorState extends AppStates{
  final String error;
  AppGetLabResultsErrorState(this.error);
}

class AppGetHomeResultsLoadingState extends AppStates{}

class AppGetHomeResultsSuccessState extends AppStates{
  final HomeResultsModel homeResultsModel;
  AppGetHomeResultsSuccessState(this.homeResultsModel);
}

class AppGetHomeResultsErrorState extends AppStates{
  final String error;
  AppGetHomeResultsErrorState(this.error);
}

class AppGetBannerLoadingState extends AppStates{}

class AppGetBannerSuccessState extends AppStates{
  final BannerModel bannerModel;
  AppGetBannerSuccessState(this.bannerModel);
}

class AppGetBannerErrorState extends AppStates{
  final String error;
  AppGetBannerErrorState(this.error);
}

class AppGetGeneralLoadingState extends AppStates{}

class AppGetGeneralSuccessState extends AppStates{
  final GeneralModel generalModel;
  AppGetGeneralSuccessState(this.generalModel);
}

class AppGetGeneralErrorState extends AppStates{
  final String error;
  AppGetGeneralErrorState(this.error);
}

class AppGetAddressLoadingState extends AppStates{}

class AppGetAddressSuccessState extends AppStates{
  final AddressModel addressModel;
  AppGetAddressSuccessState(this.addressModel);
}

class AppGetAddressErrorState extends AppStates{
  final String error;
  AppGetAddressErrorState(this.error);
}

class AppGetHomeReservationsLoadingState extends AppStates{}

class AppGetHomeReservationsSuccessState extends AppStates{
  final HomeReservationsModel labReservationsModel;
  AppGetHomeReservationsSuccessState(this.labReservationsModel);
}

class AppGetHomeReservationsErrorState extends AppStates{
  final String error;
  AppGetHomeReservationsErrorState(this.error);
}

class AppCreateTokenLoadingState extends AppStates{}

class AppCreateTokenSuccessState extends AppStates{
  final CreateTokenModel createTokenModel;
  AppCreateTokenSuccessState(this.createTokenModel);
}

class AppCreateTokenErrorState extends AppStates{
  final String error;
  AppCreateTokenErrorState(this.error);
}

class AppResetPasswordLoadingState extends AppStates{}

class AppResetPasswordSuccessState extends AppStates{
  final ResetPasswordModel resetPasswordModel;
  AppResetPasswordSuccessState(this.resetPasswordModel);
}

class AppResetPasswordErrorState extends AppStates{
  final String error;
  AppResetPasswordErrorState(this.error);
}

class AppStartFetchOTPState extends AppStates{}

class AppEndFetchOTPState extends AppStates{}

class AppChangePasswordLoadingState extends AppStates{}

class AppChangePasswordSuccessState extends AppStates{
  final SuccessModel successModel;
  AppChangePasswordSuccessState(this.successModel);
}

class AppChangePasswordErrorState extends AppStates{
  final String error;
  AppChangePasswordErrorState(this.error);
}

class AppAddToCartLoadingState extends AppStates{}

class AppAddToCartSuccessState extends AppStates{
  final SuccessModel successModel;
  AppAddToCartSuccessState(this.successModel);
}

class AppAddToCartErrorState extends AppStates{
  final String error;
  AppAddToCartErrorState(this.error);
}

class AppGetBranchesLoadingState extends AppStates{}

class AppGetBranchesSuccessState extends AppStates{
  final BranchModel branchModel;
  AppGetBranchesSuccessState(this.branchModel);
}

class AppGetBranchesErrorState extends AppStates{
  final String error;
  AppGetBranchesErrorState(this.error);
}

class AppGetLabAppointmentsLoadingState extends AppStates{}

class AppGetLabAppointmentsSuccessState extends AppStates{
  final LabAppointmentsModel labAppointmentsModel;
  AppGetLabAppointmentsSuccessState(this.labAppointmentsModel);
}

class AppGetLabAppointmentsErrorState extends AppStates{
  final String error;
  AppGetLabAppointmentsErrorState(this.error);
}

class AppGetHomeAppointmentsLoadingState extends AppStates{}

class AppGetHomeAppointmentsSuccessState extends AppStates{
  final HomeAppointmentsModel homeAppointmentsModel;
  AppGetHomeAppointmentsSuccessState(this.homeAppointmentsModel);
}

class AppGetHomeAppointmentsErrorState extends AppStates{
  final String error;
  AppGetHomeAppointmentsErrorState(this.error);
}

class AppGetCarouselLoadingState extends AppStates{}

class AppGetCarouselSuccessState extends AppStates{
  final CarouselModel carouselModel;
  AppGetCarouselSuccessState(this.carouselModel);
}

class AppGetCarouselErrorState extends AppStates{
  final String error;
  AppGetCarouselErrorState(this.error);
}

class AppGetCategoriesLoadingState extends AppStates{}

class AppGetCategoriesSuccessState extends AppStates{
  final CategoriesModel categoriesModel;
  AppGetCategoriesSuccessState(this.categoriesModel);
}

class AppGetCategoriesErrorState extends AppStates{
  final String error;
  AppGetCategoriesErrorState(this.error);
}

class AppGetOffersLoadingState extends AppStates{}

class AppGetOffersSuccessState extends AppStates{
  final OffersModel offersModel;
  AppGetOffersSuccessState(this.offersModel);
}

class AppGetOffersErrorState extends AppStates{
  final String error;
  AppGetOffersErrorState(this.error);
}

class AppGetMedicalInquiriesLoadingState extends AppStates{}

class AppGetMedicalInquiriesSuccessState extends AppStates{
  final MedicalInquiriesModel medicalInquiries;
  AppGetMedicalInquiriesSuccessState(this.medicalInquiries);
}

class AppGetMedicalInquiriesErrorState extends AppStates{
  final String error;
  AppGetMedicalInquiriesErrorState(this.error);
}

class AppGetTestsLoadingState extends AppStates{}

class AppGetTestsSuccessState extends AppStates{
  final TestsModel testsModel;
  AppGetTestsSuccessState(this.testsModel);
}

class AppGetTestsErrorState extends AppStates{
  final String error;
  AppGetTestsErrorState(this.error);
}

class AppProfileImagePickedSuccessState extends AppStates{}

class AppProfileImagePickedErrorState extends AppStates{}

class AppInquiryImagePickedSuccessState extends AppStates{}

class AppInquiryImagePickedErrorState extends AppStates{}

class AppGetTermsLoadingState extends AppStates{}

class AppGetTermsSuccessState extends AppStates{
  final TermsModel termsModel;
  AppGetTermsSuccessState(this.termsModel);
}

class AppGetTermsErrorState extends AppStates{
  final String error;
  AppGetTermsErrorState(this.error);
}

class AppLogoutSuccessState extends AppStates{}