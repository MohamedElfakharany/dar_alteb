import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/profile/region_settings/profile_change_country.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class RegionSettingsScreen extends StatefulWidget {
  const RegionSettingsScreen({Key? key}) : super(key: key);

  @override
  State<RegionSettingsScreen> createState() => _RegionSettingsScreenState();
}

class _RegionSettingsScreenState extends State<RegionSettingsScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 0),
          () {
        AppCubit.get(context).getBranch(cityID: extraCityId!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtRegionSettings.tr(),
            appBarColor: greyExtraLightColor,
            centerTitle: false,
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetBranchesLoadingState,
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSmallSpace,
                  textLabel(
                    title: LocaleKeys.languageA.tr(),
                  ),
                  verticalSmallSpace,
                  InkWell(
                    onTap: () {
                      AppCubit.get(context).changeLanguage().then((_) {
                        context.setLocale(Locale(AppCubit.get(context).local!));
                      });
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          border: Border.all(color: greyLightColor, width: 1),
                          color: whiteColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (sharedLanguage == 'ar')
                              SvgPicture.asset(
                                'assets/images/americanFlag.svg',
                                height: 40,
                                width: 60,
                              ),
                            if (sharedLanguage == 'en')
                              SvgPicture.asset(
                                'assets/images/saudiFlag.svg',
                                height: 40,
                                width: 60,
                              ),
                            horizontalSmallSpace,
                            Text(
                              LocaleKeys.language.tr(),
                              style: titleSmallStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSmallSpace,
                  textLabel(
                    title: LocaleKeys.txtBranch.tr(),
                  ),
                  verticalSmallSpace,
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        FadeRoute(
                          page: const ProfileChangeCountryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          border: Border.all(color: greyLightColor, width: 1),
                          color: whiteColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.science_outlined,
                                color: greyLightColor),
                            horizontalMiniSpace,
                            Text(
                              // '${AppCubit.get(context).branchModel!.data![extraBranchId!].title ?? ''}',
                              extraBranchTitle ?? '',
                              style: titleSmallStyle,
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: greyLightColor,
                            ),
                          ],
                        ),
                      ),
                    ),
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
