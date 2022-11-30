import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/auth/register/select_gender_screen.dart';
import 'package:dar_elteb/screens/intro_screens/widget_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class SelectBranchScreen extends StatelessWidget {
  const SelectBranchScreen(
      {Key? key, required this.countryId, required this.cityId})
      : super(key: key);
  final int countryId;
  final int cityId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
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
                    '${LocaleKeys.BtnSelect.tr()} ${LocaleKeys.txtBranch.tr()}',
                    style: titleStyle.copyWith(fontSize: 30),
                  ),
                  Text(
                    LocaleKeys.onboardingBody.tr(),
                    style: subTitleSmallStyle,
                  ),
                  verticalSmallSpace,
                  LinearProgressIndicator(
                      value: 0.775,
                      backgroundColor: greyLightColor.withOpacity(0.3),
                      color: greenColor),
                  verticalLargeSpace,
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () async {
                          AppCubit.get(context)
                              .saveExtraLocation(
                                  extraCountryId1: countryId,
                                  extraCityId1: cityId,
                                  extraBranchId1: AppCubit.get(context)
                                      .branchModel!
                                      .data![index]
                                      .id,
                                  extraBranchTitle1: AppCubit.get(context)
                                      .branchModel!
                                      .data![index]
                                      .title, extraBranchIndex1: index)
                              .then((v) {
                            if (kDebugMode) {
                              print(
                                  'countryId : $countryId cityId : $cityId branchID : ${AppCubit.get(context)
                                      .branchModel!
                                      .data![index]
                                  .id}');
                            }
                            extraBranchId = AppCubit.get(context)
                                .branchModel!
                                .data![index]
                                .id;
                            extraBranchTitle = AppCubit.get(context)
                                .branchModel!
                                .data![index]
                                .title;
                            Navigator.push(
                              context,
                              FadeRoute(
                                page: SelectGenderScreen(
                                  branchId: AppCubit.get(context)
                                      .branchModel!
                                      .data![index]
                                      .id,
                                  countryId: countryId,
                                  cityId: cityId, branchIndex: index,
                                ),
                              ),
                            );
                          });
                        },
                        child: RegionCard(
                          title: AppCubit.get(context)
                              .branchModel!
                              .data![index]
                              .title,
                        ),
                      ),
                      separatorBuilder: (context, index) => verticalSmallSpace,
                      itemCount:
                          AppCubit.get(context).branchModel!.data!.length,
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
