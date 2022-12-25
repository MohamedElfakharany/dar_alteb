import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dar_elteb/shared/components/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/tech_support_screens/create_tech_support_screen.dart';
import 'package:dar_elteb/screens/main_screens/test_items_screen/test_details_screen.dart';
import 'package:dar_elteb/screens/main_screens/test_items_screen/test_items_screen.dart';
import 'package:dar_elteb/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    permission();
    if (isVisitor == false) {
      AppCubit.get(context).getCarouselData();
      AppCubit.get(context).getTerms();
      AppCubit.get(context).getProfile();
      AppCubit.get(context).getNotifications();
      AppCubit.get(context).getCart();
    }
    if (isVisitor == true) {
      Timer(
        const Duration(microseconds: 0),
        () async {
          extraBranchTitle = await CacheHelper.getData(key: 'extraBranchTitle');
          extraCityId = await CacheHelper.getData(key: 'extraCityId');
          extraBranchId = await CacheHelper.getData(key: 'extraBranchId');
        },
      );
    }
  }

  Future<bool> permission() async {
    PermissionStatus result;
    // In Android we need to request the storage permission,
    // while in iOS is the photos permission
    if (Platform.isAndroid) {
      result = await Permission.location.request();
    } else {
      result = await Permission.locationAlways.request();
    }

    if (result.isGranted) {
      return true;
    } else if (Platform.isIOS || result.isPermanentlyDenied) {
      return false;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    String? locationValue;
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getCountry()
        ..getTerms()
        ..getGeneral()
        ..getCity(countryId: extraCountryId!)
        ..getBranch(cityID: extraCityId!)
        ..getCategories()
        ..getOffers()
        ..getNotifications()
        ..getBanner(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppGetBannerSuccessState) {
            if (state.bannerModel.status == true) {
              if (Management.dialogAppeared == false) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: InkWell(
                        onTap: () async {
                          print('tapped');
                          var url =
                              '${AppCubit.get(context).bannerModel?.data?.link}';
                          if (await canLaunchUrl(Uri(path: url))) {
                            await launchUrl(Uri(path: url));
                          } else {
                            print('tapped');
                            throw 'Could not launch $url';
                          }
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: greyDarkColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const Spacer(),
                              ],
                            ),
                            Text(
                              AppCubit.get(context).bannerModel?.data?.title ??
                                  '',
                              style: titleSmallStyle,
                            ),
                            Expanded(
                              child: CachedNetworkImageNormal(
                                height: 300,
                                width: 300,
                                imageUrl:
                                    '${AppCubit.get(context).bannerModel?.data?.image}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).then((value) => Management.dialogAppeared = true);
              }
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: greyExtraLightColor,
            body: ConditionalBuilder(
              condition: state is! AppGetBranchesLoadingState &&
                  state is! AppGetCarouselLoadingState &&
                  state is! AppGetCitiesLoadingState &&
                  state is! AppGetCountriesLoadingState &&
                  state is! AppGetRelationsLoadingState &&
                  state is! AppGetCategoriesLoadingState &&
                  state is! AppGetOffersLoadingState &&
                  state is! AppGetTestsLoadingState &&
                  state is! AppGetProfileLoadingState &&
                  cubit.branchNames != null,
              builder: (context) {
                print('fontFamily : $fontFamily');
                locationValue =
                    AppCubit.get(context).branchName[extraBranchIndex ?? 0];
                return Container(
                  color: greyExtraLightColor,
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: greyDarkColor,
                          ),
                          horizontalMiniSpace,
                          Text(
                            '${LocaleKeys.txtBranch.tr()} : ',
                            style: titleSmallStyle,
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: ConditionalBuilder(
                                condition:
                                    state is! AppGetBranchesLoadingState ||
                                        state is! AppGetCitiesLoadingState ||
                                        state is! AppGetCountriesLoadingState ||
                                        cubit.branchNames != null,
                                builder: (context) {
                                  return DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      fillColor: greyExtraLightColor,
                                      filled: true,
                                      errorStyle:
                                          TextStyle(color: Color(0xFF4F4F4F)),
                                      border: InputBorder.none,
                                    ),
                                    value: locationValue,
                                    isExpanded: true,
                                    iconSize: 30,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: greyDarkColor,
                                    ),
                                    items: AppCubit.get(context)
                                        .branchName
                                        .map(buildLocationItem)
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        locationValue = value;
                                      });
                                      // AppCubit.get(context).selectBranch(name: locationValue!);
                                    },
                                    onSaved: (v) {
                                      FocusScope.of(context).unfocus();
                                    },
                                  );
                                },
                                fallback: (context) => const Center(
                                    child: LinearProgressIndicator()),
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalMiniSpace,
                      ConditionalBuilder(
                        condition: cubit.carouselModel?.data != null,
                        builder: (context) => CarouselSlider(
                          items: cubit.carouselModel?.data!
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Container(
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(radius),
                                      color: whiteColor,
                                      border: Border.all(color: greyLightColor),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            e.image,
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 15.0, end: 15.0),
                                      // decoration: BoxDecoration(
                                      //   color: greyExtraLightColor.withOpacity(0.7),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          verticalMiniSpace,
                                          Text(
                                            e.title ?? '',
                                            style: titleSmallStyleRed.copyWith(
                                                fontSize: 20),
                                          ),
                                          verticalMiniSpace,
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              e.text ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: titleSmallStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            height: 150.0,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            scrollDirection: Axis.horizontal,
                            viewportFraction: 1.0,
                            onPageChanged: (int index, reason) {
                              AppCubit.get(context).changeCarouselState(index);
                            },
                          ),
                        ),
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      verticalMiniSpace,
                      Row(
                        children: [
                          Text(LocaleKeys.txtTestCategoriesMain.tr(),
                              style: titleStyle),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                cubit.changeBottomScreen(1);
                              });
                            },
                            child: Text(
                              LocaleKeys.BtnSeeAll.tr(),
                              style: subTitleSmallStyle,
                            ),
                          ),
                        ],
                      ),
                      verticalMiniSpace,
                      ConditionalBuilder(
                        condition: cubit.testsModel?.data?.isNotEmpty != false,
                        builder: (context) => SizedBox(
                          height: 110.0,
                          width: double.infinity,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: TestItemsScreen(
                                      categoryId: AppCubit.get(context)
                                          .categoriesModel!
                                          .data![index]
                                          .id,
                                    ),
                                  ),
                                );
                              },
                              child: CategoriesCard(
                                categoriesDataModel: AppCubit.get(context)
                                    .categoriesModel!
                                    .data![index],
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                horizontalMiniSpace,
                            itemCount: AppCubit.get(context)
                                    .categoriesModel
                                    ?.data
                                    ?.length ??
                                0,
                          ),
                        ),
                        fallback: (context) =>
                            ScreenHolder(msg: LocaleKeys.homeTxtOffers.tr()),
                      ),
                      verticalMiniSpace,
                      if (AppCubit.get(context)
                              .generalModel
                              ?.data
                              ?.technicalReservations ==
                          1)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            color: whiteColor,
                            border: Border.all(color: greyLightColor),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalMicroSpace,
                                    Text(
                                      LocaleKeys.txtHomeReservation.tr(),
                                      style: titleSmallStyle.copyWith(
                                          color: mainColor, fontSize: 20),
                                    ),
                                    verticalMicroSpace,
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        LocaleKeys.onboardingBody.tr(),
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: titleSmallStyle2,
                                      ),
                                    ),
                                    verticalMicroSpace,
                                    GeneralButton(
                                      title:
                                          '${LocaleKeys.TxtReservationScreenTitle.tr()} ${LocaleKeys.txtNow.tr()}',
                                      fontSize: 15,
                                      onPress: () {
                                        if (isVisitor ==
                                            true) {
                                          showPopUp(
                                            context,
                                            const VisitorHoldingPopUp(),
                                          );
                                        } else if (isVisitor ==
                                            false) {
                                          Navigator.push(
                                            context,
                                            FadeRoute(
                                              page:
                                                  const CreateTechSupportScreen(),
                                            ),
                                          );
                                        } else {
                                          showPopUp(
                                            context,
                                            const VisitorHoldingPopUp(),
                                          );
                                        }
                                      },
                                      height: 40,
                                    ),
                                    verticalMicroSpace,
                                    verticalMicroSpace,
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  top: 10.0,
                                  start: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Image.asset(
                                    'assets/images/homeImageReserv.png'),
                              )),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          Text(LocaleKeys.homeTxtOffers.tr(),
                              style: titleStyle),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              cubit.fromHome = true;
                              cubit.changeBottomScreen(1);
                            },
                            child: Text(
                              LocaleKeys.BtnSeeAll.tr(),
                              style: subTitleSmallStyle,
                            ),
                          ),
                        ],
                      ),
                      ConditionalBuilder(
                        condition: state is! AppGetOffersLoadingState,
                        builder: (context) => SizedBox(
                          height: 235.0,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: TestDetailsScreen(
                                      offersDataModel: AppCubit.get(context)
                                          .offersModel!
                                          .data![index],
                                    ),
                                  ),
                                );
                              },
                              child: OffersCard(
                                offersDataModel: AppCubit.get(context)
                                    .offersModel!
                                    .data![index],
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                horizontalMiniSpace,
                            itemCount: AppCubit.get(context)
                                    .offersModel
                                    ?.data
                                    ?.length ??
                                0,
                          ),
                        ),
                        fallback: (context) => const Center(
                            child: CircularProgressIndicator.adaptive()),
                      ),
                      verticalMiniSpace,
                    ],
                  ),
                );
              },
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        },
      ),
    );
  }

  DropdownMenuItem<String> buildLocationItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: titleSmallStyle,
        ),
      );
}

class Management {
  static bool dialogAppeared = false;
}
