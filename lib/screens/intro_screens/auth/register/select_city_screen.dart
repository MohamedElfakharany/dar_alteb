import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/auth/register/select_branch_screen.dart';
import 'package:dar_elteb/screens/intro_screens/widget_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class SelectCityScreen extends StatelessWidget {
  const SelectCityScreen({Key? key, required this.countryId}) : super(key: key);
  final int countryId;

  @override
  Widget build(BuildContext context) {
    var cityId;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppGetBranchesSuccessState) {
          if (state.branchModel.status) {
            Navigator.push(
              context,
              FadeRoute(
                page: SelectBranchScreen(countryId: countryId, cityId: cityId),
              ),
            );
          }
        }
      },
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
                    '${LocaleKeys.BtnSelect.tr()} ${LocaleKeys.txtCity.tr()}',
                    style: titleStyle.copyWith(fontSize: 30),
                  ),
                  Text(
                    LocaleKeys.onboardingBody.tr(),
                    style: subTitleSmallStyle,
                  ),
                  verticalSmallSpace,
                  LinearProgressIndicator(
                      value: 0.625,
                      backgroundColor: greyLightColor.withOpacity(0.3),
                      color: greenColor),
                  verticalLargeSpace,
                  Expanded(
                    child: ConditionalBuilder(
                      condition: state is! AppGetBranchesLoadingState,
                      builder: (context) => ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            cityId = cubit.cityModel!.data![index].id;
                            extraCityId = cityId;
                            cubit.getBranch(
                                cityID: cubit.cityModel!.data![index].id);
                          },
                          child: RegionCard(
                            title: cubit.cityModel!.data![index].title,
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            verticalSmallSpace,
                        itemCount: cubit.cityModel!.data!.length,
                      ),
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
