// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/home_layout_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ReservedSuccessScreen extends StatelessWidget {
  ReservedSuccessScreen({Key? key, required this.time, required this.date, required this.branchName, required this.isLab}) : super(key: key);
  final String time;
  final String date;
  final String branchName;
  bool? isLab;
  @override
  Widget build(BuildContext context) {
    String where;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if(isLab == true){
          where = LocaleKeys.BtnAtLab.tr();
        }else{
          where = LocaleKeys.BtnAtHome.tr();
        }
        return Scaffold(
          backgroundColor: whiteColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/success.jpg',
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.6,
                // color: blueColor,
              ),
              Text(
                LocaleKeys.txtReservationSuccess.tr(),
                style: titleStyle.copyWith(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '$where,\n $branchName ,\n $date,\n at $time',
                  style: titleSmallStyle.copyWith(
                    color: greyDarkColor,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              verticalSmallSpace,
              MaterialButton(
                onPressed: () {
                  AppCubit.get(context).changeBottomScreen(0);
                  navigateAndFinish(context, const HomeLayoutScreen());
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: Center(
                    child: Text(
                      LocaleKeys.txtBackToHome.tr(),
                      style: titleStyle.copyWith(
                          fontSize: 15.0,
                          color: whiteColor,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //   },
              //   child: Text(
              //
              //     style: titleSmallStyle.copyWith(
              //       color: greyDarkColor,
              //       fontWeight: FontWeight.normal,
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
