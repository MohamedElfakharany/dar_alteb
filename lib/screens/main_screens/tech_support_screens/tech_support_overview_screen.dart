// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/reservations/reserved_success_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class TechSupportOverviewScreen extends StatefulWidget {
  TechSupportOverviewScreen({
    Key? key,
    required this.date,
    required this.time,
    this.familyName,
    required this.addressTitle,
    required this.addressId,
  }) : super(key: key);
  String? familyName;
  final String addressTitle;
  final String date;
  final String time;
  int? addressId;

  @override
  State<TechSupportOverviewScreen> createState() =>
      _TechSupportOverviewScreenState();
}

class _TechSupportOverviewScreenState extends State<TechSupportOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreateTechnicalRequestsSuccessState) {
          if (state.successModel.status) {
            navigateAndFinish(
              context,
              ReservedSuccessScreen(
                time: widget.time,
                date: widget.date,
                branchName: widget.addressTitle,
                isLab: false,
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.successModel.message),
                );
              },
            );
          }
        } else if (state is AppCreateTechnicalRequestsErrorState){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  state.error.toString()
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtOverview.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  LocaleKeys.txtReservationDetails.tr(),
                  style: titleStyle.copyWith(fontWeight: FontWeight.w500),
                ),
                verticalMiniSpace,
                Container(
                  height: 260.0,
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
                                if (isVisitor == false)
                                  Text(
                                    widget.familyName ??
                                        AppCubit.get(context)
                                            .userResourceModel
                                            ?.data
                                            ?.name,
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
                      myHorizontalDivider(),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.TxtPopUpReservationType.tr(),
                                    style: titleStyle.copyWith(
                                        color: greyLightColor),
                                  ),
                                  if (isVisitor == false)
                                    Text(
                                      widget.addressTitle,
                                      textAlign: TextAlign.start,
                                      style: titleSmallStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      myHorizontalDivider(),
                      Expanded(
                        child: Row(
                          children: [
                            horizontalSmallSpace,
                            Image.asset(
                              'assets/images/reservedSelected.png',
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
                                  '${widget.date}  &  ${widget.time}',
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
                verticalLargeSpace,
                verticalLargeSpace,
                ConditionalBuilder(
                  condition: state is! AppCreateTechnicalRequestsLoadingState,
                  builder: (context) => MaterialButton(
                    onPressed: () {
                      AppCubit.get(context).createTechnicalRequests(
                        addressId: widget.addressId,
                        time: widget.time,
                        date: widget.date,
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      child: Center(
                        child: Text(
                          LocaleKeys.BtnConfirm.tr(),
                          style: titleStyle.copyWith(
                            fontSize: 20.0,
                            color: whiteColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
