import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/widget_components.dart';
import 'package:dar_elteb/screens/main_screens/profile/region_settings/profile_change_city.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ProfileChangeCountryScreen extends StatelessWidget {
  const ProfileChangeCountryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getCountry(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: GeneralAppBar(title: ''),
            body: Container(
              color: whiteColor,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 20.0, right: 20.0, left: 20.0),
                child: Column(
                  children: [
                    verticalSmallSpace,
                    Text(
                      '${LocaleKeys.BtnSelect.tr()} ${LocaleKeys.txtCountry.tr()}',
                      style: titleStyle.copyWith(fontSize: 30),
                    ),
                    Text(
                      LocaleKeys.onboardingBody.tr(),
                      style: subTitleSmallStyle,
                    ),
                    verticalLargeSpace,
                    Expanded(
                      child: ConditionalBuilder(
                        condition: state is! AppGetCountriesLoadingState && state is! AppGetCitiesLoadingState,
                        builder: (context) => ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => InkWell(onTap: (){
                            // AppCubit.get(context).getCity(countryId: cubit.countryModel!.data![index].id);
                            Navigator.push(
                              context,
                              FadeRoute(
                                page: ProfileChangeCityScreen(countryId: cubit.countryModel!.data![index].id,),
                              ),
                            );
                          },child: RegionCard(title: cubit.countryModel!.data![index].title)),
                          separatorBuilder: (context, index) => verticalSmallSpace,
                          itemCount: cubit.countryModel!.data!.length,
                        ),
                        fallback: (context) => const Center(child: CircularProgressIndicator.adaptive()),
                      ),
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
