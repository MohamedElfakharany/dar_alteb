import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/screens/intro_screens/auth/login_screen.dart';
import 'package:dar_elteb/screens/intro_screens/startup/onboarding_screen.dart';
import 'package:dar_elteb/screens/intro_screens/startup/select_lang_screen.dart';
import 'package:dar_elteb/screens/main_screens/home_layout_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/tech_lib/tech_home_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Widget widget;
    token = CacheHelper.getData(key: 'token');
    type = CacheHelper.getData(key: 'type');
    isFirst = CacheHelper.getData(key: 'isFirst');
    sharedLanguage = CacheHelper.getData(key: 'local');
    verified = CacheHelper.getData(key: 'verified');
    extraCountryId = CacheHelper.getData(key: 'extraCountryId');
    extraCityId = CacheHelper.getData(key: 'extraCityId');
    extraBranchId = CacheHelper.getData(key: 'extraBranchId');
    extraBranchTitle = CacheHelper.getData(key: 'extraBranchTitle');
    isEnglishShared = CacheHelper.getData(key: 'isEnglish');

    isEnglishShared ??= false;

    if (sharedLanguage == 'en') {
      fontFamily = 'Poppins';
    } else {
      fontFamily = 'Cairo';
    }

    if (kDebugMode) {
      printWrapped('from main the token is $token');
      printWrapped('from main the type is $type');
      printWrapped('from main the isFirst is $isFirst');
      printWrapped('from main the verified is $verified');
      printWrapped('from main the sharedLanguage is $sharedLanguage');
      printWrapped('from main the isEnglishShared is $isEnglishShared');
      printWrapped('from main the extraCountryId is $extraCountryId');
      printWrapped('from main the extraCityId is $extraCityId');
      printWrapped('from main the extraBranchId is $extraBranchId');
      printWrapped('from main the extraBranchTitle is $extraBranchTitle');
    }

    if (token != null) {
      if (verified != null) {
        if (verified == 1) {
          if (type == 'Technical') {
            widget = const TechHomeLayoutScreen();
          } else {
            isVisitor = false;
            widget = const HomeLayoutScreen();
          }
        } else {
          widget = const LoginScreen();
        }
      } else {
        if (isFirst != null) {
          widget = OnBoardingScreen(
            isSignOut: false,
          );
        } else {
          widget = const SelectLangScreen();
        }
      }
    } else {
      widget = const SelectLangScreen();
    }

    super.initState();
    Timer(
      const Duration(milliseconds: 2000),
      () {
        navigateAndFinish(context, widget);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              appLogo,
              width: 250,
              height: 250,
            ),
            verticalLargeSpace,
            verticalLargeSpace,
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
