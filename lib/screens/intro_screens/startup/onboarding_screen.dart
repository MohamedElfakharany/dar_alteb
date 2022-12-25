// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/auth/login_screen.dart';
import 'package:dar_elteb/screens/intro_screens/auth/register/select_country_screen.dart';
import 'package:dar_elteb/screens/intro_screens/auth/register/sign_up_screen.dart';
import 'package:dar_elteb/shared/components/cached_network_image.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key, this.isSignOut}) : super(key: key);
  bool? isSignOut = false;

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLast = false;
  var boardController = PageController();

  @override
  void initState() {
    AppCubit.get(context).getOnboarding();
  }

  // Future getData() async {
  //   await AppCubit.get(context).getOnboarding();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppGetCountriesSuccessState) {
          if (state.countriesModel.status) {
            Navigator.push(
              context,
              FadeRoute(
                page: const SelectCountryScreen(),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  content: Text(
                state.countriesModel.message,
              )),
            );
          }
        } else if (state is AppGetCountriesErrorState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                content: Text(
              state.error,
            )),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context).onBoardingModel;
        var item1 = cubit?.data?.onboarding1;
        var item2 = cubit?.data?.onboarding2;
        var item3 = cubit?.data?.onboarding3;
        return Scaffold(
          backgroundColor: whiteColor,
          body: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 30.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
                    controller: boardController,
                    children: [
                      buildBoardingItem(
                        title: '${item1?.title ?? ''}',
                        image: '${item1?.image ?? ''}',
                        description: '${item1?.description ?? ''}',
                      ),
                      buildBoardingItem(
                        title: '${item2?.title ?? ''}',
                        image: '${item2?.image ?? ''}',
                        description: '${item2?.description ?? ''}',
                      ),
                      buildBoardingItem(
                        title: '${item3?.title ?? ''}',
                        image: '${item3?.image ?? ''}',
                        description: '${item3?.description ?? ''}',
                      ),
                    ],
                  ),
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: boardController,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 4,
                      spacing: 5,
                      activeDotColor: mainColor,
                    ), // your preferred effect
                  ),
                ),
                // verticalMicroSpace,
                SizedBox(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Expanded(
                        //   child: GeneralUnfilledButton(
                        //     width: double.infinity,
                        //     title: 'Sign in',
                        //     onPress: () {
                        //       Navigator.push(
                        //         context,
                        //         FadeRoute(
                        //           page: const LoginScreen(),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: const LoginScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: blueColor,
                                  borderRadius:
                                  BorderRadius.circular(radius),
                                ),
                                height: 50.0,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    LocaleKeys.BtnSignIn.tr(),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: titleSmallStyle.copyWith(
                                        color: mainColor, fontSize: 14),
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  mainColor),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: const SignUpScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius:
                                BorderRadius.circular(radius),
                              ),
                              height: 50.0,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  LocaleKeys.BtnRegister.tr(),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: titleSmallStyle.copyWith(
                                    color: whiteColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    isVisitor = true;
                    AppCubit.get(context).getCountry();
                  },
                  child: Text(
                    LocaleKeys.BtnContinueAsGuest.tr(),
                    style: titleSmallStyle.copyWith(color: mainColor),
                  ),
                ),
              ],
            ),
          ),
          // FutureBuilder(
          //
          //   future: getData(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return ;
          //     } else {
          //       return const Center(
          //         child: CircularProgressIndicator.adaptive(),
          //       );
          //     }
          //   },
          // ),
        );
      },
    );
  }

  Widget buildBoardingItem({
    required String image,
    required String title,
    required String description,
  }) =>
      ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalMiniSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CachedNetworkImageNormal(
              imageUrl: image,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          verticalMiniSpace,
          Text(
            "$title",
            textAlign: TextAlign.center,
            style: titleStyle,
          ),
          verticalMiniSpace,
          Text(
            "$description",
            textAlign: TextAlign.center,
            style: subTitleSmallStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          verticalMediumSpace,
        ],
      );
}
