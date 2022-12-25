// ignore_for_file: must_be_immutable, unnecessary_import

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_reservation_model.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_reservation_model.dart';
import 'package:dar_elteb/screens/main_screens/home_layout_screen.dart';
import 'package:dar_elteb/screens/main_screens/reservations/widget_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ReservationDetailsUpcomingScreen extends StatelessWidget {
  ReservationDetailsUpcomingScreen(
      {Key? key,
      this.labReservationsModel,
      this.homeReservationsModel,
      required this.topIndex})
      : super(key: key);
  LabReservationsModel? labReservationsModel;
  HomeReservationsModel? homeReservationsModel;
  final int topIndex;

  @override
  Widget build(BuildContext context) {
    String title;
    String image;
    int price;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCancelLabReservationSuccessState) {
          if (state.successModel.status) {
            showToast(
                msg: state.successModel.message, state: ToastState.success);
            Navigator.pop(context);
            Navigator.pop(context);
            AppCubit.get(context).changeBottomScreen(0);
          } else {
            showToast(msg: state.successModel.message, state: ToastState.error);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        } else if (state is AppCancelLabReservationErrorState) {
          showToast(msg: state.error, state: ToastState.error);
          Navigator.pop(context);
        }

        if (state is AppCancelHomeReservationSuccessState) {
          if (state.successModel.status) {
            showToast(
                msg: state.successModel.message, state: ToastState.success);
            Navigator.pop(context);
            Navigator.pop(context);
            AppCubit.get(context).changeBottomScreen(0);
          } else {
            showToast(msg: state.successModel.message, state: ToastState.error);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        } else if (state is AppCancelHomeReservationErrorState) {
          showToast(msg: state.error, state: ToastState.error);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var labReservationsDataModel = labReservationsModel?.data?[topIndex];
        var homeReservationsDataModel = homeReservationsModel?.data?[topIndex];
        Color stateColor;
        if (labReservationsDataModel?.statusEn == 'Pending' ||
            homeReservationsDataModel?.statusEn == 'Pending') {
          stateColor = pendingColor;
        } else if (labReservationsDataModel?.statusEn == 'Accepted' ||
            homeReservationsDataModel?.statusEn == 'Accepted') {
          stateColor = acceptedColor;
        } else if (labReservationsDataModel?.statusEn == 'Sampling' ||
            homeReservationsDataModel?.statusEn == 'Sampling') {
          stateColor = samplingColor;
        } else if (labReservationsDataModel?.statusEn == 'Finished' ||
            homeReservationsDataModel?.statusEn == 'Finished') {
          stateColor = finishedColor;
        } else {
          stateColor = canceledColor;
        }
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtReservationDetails.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
            leading: IconButton(
              onPressed: () {
                AppCubit.get(context).changeBottomScreen(2);
                navigateAndFinish(context, const HomeLayoutScreen());
              },
              icon: const Icon(
                Icons.arrow_back,
                color: greyDarkColor,
              ),
            ),
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetLabReservationsLoadingState ||
                state is! AppGetHomeReservationsLoadingState,
            builder: (context) => Padding(
              padding:
                  const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(width: 1, color: greyLightColor),
                    ),
                    alignment: AlignmentDirectional.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '# ${homeReservationsModel?.data?[topIndex].id ?? labReservationsDataModel?.id}',
                          ),
                          const Spacer(),
                          Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: stateColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                homeReservationsModel?.data?[topIndex].status ??
                                    labReservationsDataModel?.status,
                                style: titleStyle.copyWith(
                                    fontSize: 15.0,
                                    color: stateColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSmallSpace,
                  if (homeReservationsDataModel != null)
                    if (homeReservationsDataModel.tests!.isNotEmpty)
                      SizedBox(
                        height: 120.0 * (homeReservationsDataModel.tests?.length ?? 0),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            title = homeReservationsDataModel.tests![index].title;
                            price = homeReservationsDataModel.tests![index].price;
                            image = homeReservationsDataModel.tests![index].image;
                            return ReservationInCartCard(
                              title: title,
                              image: image,
                              price: price,
                            );
                          },
                          separatorBuilder: (context, index) => verticalMiniSpace,
                          itemCount:
                          ((homeReservationsDataModel.offers?.length ?? 0) +
                              (homeReservationsDataModel.tests?.length ?? 0)),
                        ),
                      ),
                  if (homeReservationsDataModel != null)
                    if (homeReservationsDataModel.offers!.isNotEmpty)
                      SizedBox(
                        height: 120.0 * (homeReservationsDataModel.offers?.length ?? 0) ,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            title = homeReservationsDataModel.offers?[index].title ?? '';
                            price = homeReservationsDataModel.offers?[index].price ?? '';
                            image = homeReservationsDataModel.offers?[index].image ?? '';
                            return ReservationInCartCard(
                              title: title,
                              image: image,
                              price: price,
                            );
                          },
                          separatorBuilder: (context, index) => verticalMiniSpace,
                          itemCount:
                          ((homeReservationsDataModel.offers?.length ?? 0) +
                              (homeReservationsDataModel.tests?.length ?? 0)),
                        ),
                      ),
                  if (labReservationsDataModel != null)
                    if (labReservationsDataModel.tests!.isNotEmpty)
                      SizedBox(
                      height: 120.0 * (labReservationsDataModel.tests?.length ?? 0),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          title = labReservationsDataModel.tests![index].title;
                          price = labReservationsDataModel.tests![index].price;
                          image = labReservationsDataModel.tests![index].image;
                          return ReservationInCartCard(
                            title: title,
                            image: image,
                            price: price,
                          );
                        },
                        separatorBuilder: (context, index) => verticalMiniSpace,
                        itemCount:
                            ((labReservationsDataModel.offers?.length ?? 0) +
                                (labReservationsDataModel.tests?.length ?? 0)),
                      ),
                    ),
                  if (labReservationsDataModel != null)
                    if (labReservationsDataModel.offers!.isNotEmpty)
                      SizedBox(
                      height: 120.0 * (labReservationsDataModel.offers?.length ?? 0) ,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          title = labReservationsDataModel.offers![index].title;
                          price = labReservationsDataModel.offers![index].price;
                          image = labReservationsDataModel.offers![index].image;
                          return ReservationInCartCard(
                            title: title,
                            image: image,
                            price: price,
                          );
                        },
                        separatorBuilder: (context, index) => verticalMiniSpace,
                        itemCount:
                        ((labReservationsDataModel.offers?.length ?? 0) +
                            (labReservationsDataModel.tests?.length ?? 0)),
                      ),
                    ),
                  verticalMiniSpace,
                  Text(
                    LocaleKeys.txtReservationDetails.tr(),
                    style: titleStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                  verticalMiniSpace,
                  Container(
                    height: 240.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    alignment: AlignmentDirectional.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              horizontalSmallSpace,
                              Image.asset(
                                'assets/images/profile.png',
                                width: 25,
                                height: 35,
                                color: mainColor,
                              ),
                              myVerticalDivider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.txtPatient.tr(),
                                    style: titleStyle.copyWith(
                                        color: greyLightColor),
                                  ),
                                  Text(
                                    '${AppCubit.get(context).userResourceModel?.data?.name}',
                                    textAlign: TextAlign.start,
                                    style: titleSmallStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              horizontalSmallSpace,
                              Image.asset(
                                'assets/images/location.jpg',
                                width: 25,
                                height: 35,
                              ),
                              myVerticalDivider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.txtReservationDetails.tr(),
                                    style: titleStyle.copyWith(
                                        color: greyLightColor),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      '${homeReservationsModel?.data?[topIndex].address?.address ?? labReservationsDataModel?.branch?.title ?? ''}  ${homeReservationsModel?.data?[topIndex].address?.specialMark ?? ''}',
                                      textAlign: TextAlign.start,
                                      style: subTitleSmallStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              horizontalSmallSpace,
                              Image.asset(
                                'assets/images/reserved.png',
                                width: 25,
                                height: 35,
                                color: mainColor,
                              ),
                              myVerticalDivider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.AppointmentScreenTxtTitle.tr(),
                                    style: titleStyle.copyWith(
                                        color: greyLightColor),
                                  ),
                                  Text(
                                    '${labReservationsDataModel?.date ?? homeReservationsModel?.data?[topIndex].date} - ${labReservationsDataModel?.time ?? homeReservationsModel?.data?[topIndex].time}',
                                    textAlign: TextAlign.start,
                                    style: titleSmallStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalMiniSpace,
                  Container(
                    // height: 205.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    alignment: AlignmentDirectional.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            LocaleKeys.txtSummary.tr(),
                            style: titleSmallStyle.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        myHorizontalDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.txtPrice.tr(),
                                    style: titleSmallStyle.copyWith(
                                        color: greyDarkColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${labReservationsDataModel?.price ?? homeReservationsModel?.data?[topIndex].price} ${LocaleKeys.salary.tr()}',
                                    textAlign: TextAlign.start,
                                    style: titleSmallStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              verticalMicroSpace,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.txtVAT.tr(),
                                    style: titleSmallStyle.copyWith(
                                        color: greyDarkColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${labReservationsDataModel?.tax ?? homeReservationsDataModel?.tax} %',
                                    textAlign: TextAlign.start,
                                    style: titleSmallStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              verticalMicroSpace,
                              const MySeparator(),
                              verticalMicroSpace,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.txtTotal.tr(),
                                    style: titleSmallStyle.copyWith(
                                        color: greyDarkColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${labReservationsDataModel?.total ?? homeReservationsDataModel?.total} ${LocaleKeys.salary.tr()}',
                                    textAlign: TextAlign.start,
                                    style: titleSmallStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              verticalMicroSpace,
                              verticalMicroSpace,
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys.txtAddedTax.tr(),
                                    textAlign: TextAlign.start,
                                    style: titleSmallStyle.copyWith(
                                        color: greyDarkColor,
                                        fontWeight: FontWeight.normal),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSmallSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (labReservationsDataModel?.statusEn == 'Pending' ||
                          homeReservationsDataModel?.statusEn == 'Pending')
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              showPopUp(
                                context,
                                Container(
                                  height: 400,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      verticalSmallSpace,
                                      Image.asset(
                                        'assets/images/warning-2.jpg',
                                        width: 50,
                                        height: 50,
                                      ),
                                      verticalMediumSpace,
                                      Text(
                                        LocaleKeys.txtPopUpMainCancelReservation
                                            .tr(),
                                        textAlign: TextAlign.center,
                                        style: titleStyle.copyWith(
                                          color: redColor,
                                        ),
                                      ),
                                      verticalMediumSpace,
                                      Text(
                                        LocaleKeys
                                            .txtPopUpSecondaryCancelReservation
                                            .tr(),
                                        textAlign: TextAlign.center,
                                        style: subTitleSmallStyle,
                                      ),
                                      verticalMediumSpace,
                                      verticalSmallSpace,
                                      ConditionalBuilder(
                                        condition: state
                                                is! AppCancelLabReservationLoadingState ||
                                            state
                                                is! AppCancelHomeReservationLoadingState,
                                        builder: (context) => GeneralButton(
                                          radius: radius,
                                          btnBackgroundColor: redColor,
                                          title: LocaleKeys
                                              .txtUnderstandContinue
                                              .tr(),
                                          onPress: () {
                                            if (labReservationsModel == null) {
                                              AppCubit.get(context)
                                                  .cancelHomeReservations(
                                                      reservationId:
                                                          homeReservationsModel
                                                                  ?.data?[
                                                                      topIndex]
                                                                  .id ??
                                                              labReservationsDataModel
                                                                  ?.id);
                                            } else if (homeReservationsModel ==
                                                null) {
                                              AppCubit.get(context)
                                                  .cancelLabReservations(
                                                      reservationId:
                                                          homeReservationsModel
                                                                  ?.data?[
                                                                      topIndex]
                                                                  .id ??
                                                              labReservationsDataModel
                                                                  ?.id);
                                            }
                                          },
                                        ),
                                        fallback: (context) => const Center(
                                            child: CircularProgressIndicator
                                                .adaptive()),
                                      ),
                                      GeneralButton(
                                        radius: radius,
                                        btnBackgroundColor: greyExtraLightColor,
                                        txtColor: greyDarkColor,
                                        title: LocaleKeys.BtnCancel.tr(),
                                        onPress: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: redColor,
                                borderRadius: BorderRadius.circular(radius),
                              ),
                              child: Center(
                                  child: Text(
                                LocaleKeys.BtnCancel.tr(),
                                style: titleStyle.copyWith(
                                    fontSize: 20.0,
                                    color: whiteColor,
                                    fontWeight: FontWeight.normal),
                              )),
                            ),
                          ),
                        ),
                      MaterialButton(
                        onPressed: () async {
                          await FlutterPhoneDirectCaller.callNumber(
                              '${homeReservationsModel?.extra?.phone ?? labReservationsModel?.extra?.phone}');
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.wifi_calling_3,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
      },
    );
  }
}
