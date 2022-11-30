// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_appointments_model.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_appointment_model.dart';
import 'package:dar_elteb/shared/components/cached_network_image.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class LabAppointmentsCard extends StatelessWidget {
  LabAppointmentsCard({Key? key, this.labAppointmentsDataModel})
      : super(key: key);

  LabAppointmentsDataModel? labAppointmentsDataModel;

  @override
  Widget build(BuildContext context) {
    Color cardBgColor;
    Color fontColor;
    if (labAppointmentsDataModel?.isUsed){
      cardBgColor = whiteColor;
      fontColor = darkColor;
    }else {
      cardBgColor = greyLightColor.withOpacity(0.2);
      fontColor = greyDarkColor;
    }
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          child: Text(
            labAppointmentsDataModel?.time,
            textAlign: TextAlign.center,
            style: titleSmallStyle.copyWith(color: fontColor),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

class HomeAppointmentsCard extends StatelessWidget {
  HomeAppointmentsCard({Key? key, required this.index, this.homeAppointmentsModel}) : super(key: key);
  HomeAppointmentsModel? homeAppointmentsModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    Color cardBgColor;
    Color fontColor;
    HomeAppointmentsDataModel homeAppointmentsDataModel = homeAppointmentsModel!.data![index];
    if (homeAppointmentsDataModel.isUsed){
      cardBgColor = whiteColor;
      fontColor = darkColor;
    }else {
      cardBgColor = greyLightColor.withOpacity(0.2);
      fontColor = greyDarkColor;
    }
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            height: 95,
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: cardBgColor,
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${LocaleKeys.txtPeriod.tr()} ${index+1}',
                    style: titleSmallStyle.copyWith(color: fontColor),
                  ),
                  verticalMicroSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            LocaleKeys.txtStartAt.tr(),
                            style: titleSmallStyle.copyWith(color: fontColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            homeAppointmentsDataModel.from,
                            style: subTitleSmallStyle.copyWith(color: fontColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            LocaleKeys.txtEndAt.tr(),
                            style: titleSmallStyle.copyWith(color: fontColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            homeAppointmentsDataModel.to,
                            style: subTitleSmallStyle.copyWith(color: fontColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ReservationInCartCard extends StatelessWidget {
  ReservationInCartCard({Key? key, this.image, this.price, this.title}) : super(key: key);
  String? image;
  int? price;
  String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.0,
      width: 110.0,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          width: 1,
          color: greyLightColor,
        ),
      ),
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.symmetric(
          vertical: 0, horizontal: 4),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Row(
            children: [
              horizontalMicroSpace,
              CachedNetworkImageNormal(
                imageUrl: image ?? '',
                width: 80,
                height: 80,
              ),
              horizontalSmallSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      title ?? '',
                      style: titleSmallStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$price ${LocaleKeys.salary.tr()}',
                      style: titleSmallStyle2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
