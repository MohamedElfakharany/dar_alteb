import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/widget_components.dart';
import 'package:dar_elteb/screens/main_screens/profile/region_settings/profile_change_branch.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ProfileChangeCityScreen extends StatelessWidget {
  const ProfileChangeCityScreen({Key? key, required this.countryId})
      : super(key: key);

  final int countryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AppCubit()..getCity(countryId: countryId),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: GeneralAppBar(title: ''),
            body: Container(
              color: whiteColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, right: 20.0, left: 20.0),
                child: Column(
                  children: [
                    verticalSmallSpace,
                    Text(
                      '${LocaleKeys.BtnSelect.tr()} ${LocaleKeys.txtCity.tr()}',
                      style: titleStyle.copyWith(fontSize: 30),
                    ),
                    Text(
                      LocaleKeys.onboardingBody.tr(),
                      style: subTitleSmallStyle,
                    ),
                    verticalLargeSpace,
                    ConditionalBuilder(
                      condition: state is! AppGetCitiesLoadingState &&
                          state is! AppGetBranchesLoadingState,
                      builder: (context) => Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async {
                              await CacheHelper.saveData(
                                      key: 'extraCityId',
                                      value: cubit.cityModel!.data![index].id)
                                  .then(
                                (v) => {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: ProfileChangeBranchScreen(
                                        cityId:
                                            cubit.cityModel!.data![index].id,
                                        countryId: countryId,
                                      ),
                                    ),
                                  )
                                },
                              );
                            },
                            child: RegionCard(
                              title: cubit.cityModel!.data![index].title,
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              verticalSmallSpace,
                          itemCount: cubit.cityModel!.data!.length,
                        ),
                      ),
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator.adaptive()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
