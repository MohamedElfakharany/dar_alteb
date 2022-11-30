import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/tech_lib/tech_screens/tech_map_screen.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class UserRequestsCart extends StatelessWidget {
  const UserRequestsCart({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var techRequests =
            AppCubit.get(context).patientTechnicalSupportModel?.data;
        return Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 1,
              color: greyLightColor,
            ),
          ),
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('#${techRequests?.id ?? 0}'),
                  const Spacer(),
                ],
              ),
              Text('${techRequests?.date?.date} - ${techRequests?.date?.time}'),
              myHorizontalDivider(),
              verticalMicroSpace,
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: greyDarkColor,
                    ),
                    horizontalMiniSpace,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${techRequests?.address?.address}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: TechMapScreen(
                                      lat: techRequests?.address?.latitude,
                                      long: techRequests?.address?.longitude),
                                ),
                              );
                            },
                            child: Text(
                              LocaleKeys.txtShowMap.tr(),
                              style: titleSmallStyle2.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: mainColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    horizontalMiniSpace,
                  ],
                ),
              ),
              if (techRequests?.statusEn == 'Pending')
              myHorizontalDivider(),
              if (techRequests?.statusEn == 'Pending')
              MaterialButton(
                onPressed: () {
                  showPopUp(
                    context,
                    Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width * 0.9,
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
                            LocaleKeys.txtPopUpMainCancelReservation.tr(),
                            textAlign: TextAlign.center,
                            style: titleStyle.copyWith(
                              color: redColor,
                            ),
                          ),
                          verticalMediumSpace,
                          Text(
                            LocaleKeys.txtPopUpSecondaryCancelReservation.tr(),
                            textAlign: TextAlign.center,
                            style: subTitleSmallStyle,
                          ),
                          verticalMediumSpace,
                            ConditionalBuilder(
                              condition:
                                  state is! AppCancelTechRequestsLoadingState,
                              builder: (context) => GeneralButton(
                                radius: radius,
                                btnBackgroundColor: redColor,
                                title: LocaleKeys.txtUnderstandContinue.tr(),
                                onPress: () {
                                  AppCubit.get(context).cancelTechRequest(
                                      technicalRequestId: techRequests?.id);
                                },
                              ),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator.adaptive()),
                            ),
                          verticalSmallSpace,
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
            ],
          ),
        );
      },
    );
  }
}
