// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/startup/onboarding_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';

class SelectLangScreen extends StatefulWidget {
  const SelectLangScreen({Key? key}) : super(key: key);

  @override
  State<SelectLangScreen> createState() => _SelectLangScreenState();
}

class _SelectLangScreenState extends State<SelectLangScreen> {
  @override
  Widget build(BuildContext context) {
    bool isEnglish = isEnglishShared!;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0.0,
          ),
          body: Container(
            color: whiteColor,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 20.0, right: 20.0, left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    appLogo,
                    width: 150,
                    height: 150,
                  ),
                  verticalLargeSpace,
                  InkWell(
                    onTap: () async {
                      isFirst = false;
                      CacheHelper.saveData(key: 'isFirst', value: false);
                      if (sharedLanguage == 'en') {
                        await AppCubit.get(context).changeLanguage();
                        await context.setLocale(Locale(sharedLanguage!));
                        setState(() async {
                          setState(() {
                            Navigator.push(
                                context, FadeRoute(page: OnBoardingScreen()));
                          });
                        });
                      } else if (sharedLanguage == 'ar') {
                        await context.setLocale(Locale(sharedLanguage!));
                        setState(() async {
                          Navigator.push(
                              context, FadeRoute(page: OnBoardingScreen()));
                        });
                      } else {
                        await context.setLocale(const Locale('ar'));
                        setState(() async {
                          CacheHelper.saveData(key: 'local', value: 'ar');
                          Navigator.push(
                              context, FadeRoute(page: OnBoardingScreen()));
                        });
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        border: Border.all(
                            color: isEnglish ? greyLightColor : greenColor,
                            width: 1),
                        color: isEnglish
                            ? whiteColor
                            : greenColor.withOpacity(0.16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/saudiFlag.svg',
                              height: 40,
                              width: 60,
                            ),
                            horizontalMiniSpace,
                            const Text(
                              'اللغة العربية',
                              style: titleSmallStyle,
                            ),
                            const Spacer(),
                            if (!isEnglish)
                              SvgPicture.asset(
                                'assets/images/checkTrue.svg',
                                height: 25,
                                width: 25,
                              ),
                            horizontalMicroSpace,
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSmallSpace,
                  InkWell(
                    onTap: () {
                      isFirst = false;
                      CacheHelper.saveData(key: 'isFirst', value: false);
                      setState(() async {
                        if (sharedLanguage == 'ar') {
                          await AppCubit.get(context).changeLanguage();
                          await context
                              .setLocale(Locale(sharedLanguage!))
                              .then((value) {
                            Navigator.push(
                                context, FadeRoute(page: OnBoardingScreen()));
                          });
                        } else if (sharedLanguage == 'en') {
                          await context
                              .setLocale(Locale(sharedLanguage!))
                              .then((value) {
                            Navigator.push(
                                context, FadeRoute(page: OnBoardingScreen()));
                          });
                        } else {
                          await context
                              .setLocale(const Locale('en'))
                              .then((value) {
                            CacheHelper.saveData(key: 'local', value: 'en');
                            Navigator.push(
                                context, FadeRoute(page: OnBoardingScreen()));
                          });
                        }
                        // if (!AppCubit.get(context).isEnglish) {
                        //   AppCubit.get(context).changeLang();
                        // }
                        // print(AppCubit.get(context).isEnglish);
                      });
                      if (kDebugMode) {
                        print(sharedLanguage);
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        border: Border.all(
                            color: isEnglish ? greenColor : greyLightColor,
                            width: 1),
                        color: isEnglish
                            ? greenColor.withOpacity(0.16)
                            : whiteColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/americanFlag.svg',
                              height: 40,
                              width: 60,
                            ),
                            horizontalMiniSpace,
                            const Text(
                              'English',
                              style: titleSmallStyle,
                            ),
                            const Spacer(),
                            if (isEnglish)
                              SvgPicture.asset(
                                'assets/images/checkTrue.svg',
                                height: 25,
                                width: 25,
                              ),
                            horizontalMicroSpace,
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalLargeSpace,
                  // GeneralButton(
                  //     title: 'Keep going',
                  //     onPress: () {
                  //       Navigator.push(
                  //         context,
                  //         FadeRoute(
                  //           page:  OnBoardingScreen(),
                  //         ),
                  //       );
                  //     }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
