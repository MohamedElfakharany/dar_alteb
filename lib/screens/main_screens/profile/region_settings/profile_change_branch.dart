import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/widget_components.dart';
import 'package:dar_elteb/screens/main_screens/home_layout_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ProfileChangeBranchScreen extends StatefulWidget {
  const ProfileChangeBranchScreen(
      {Key? key, required this.countryId, required this.cityId})
      : super(key: key);
  final int countryId;
  final int cityId;

  @override
  State<ProfileChangeBranchScreen> createState() =>
      _ProfileChangeBranchScreenState();
}

class _ProfileChangeBranchScreenState extends State<ProfileChangeBranchScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(microseconds: 0),
      () {
        AppCubit.get(context).getBranch(cityID: widget.cityId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppChangeLocationSuccessState) {
          if (state.successModel.status) {
            AppCubit.get(context).currentIndex = 0;
            navigateAndFinish(context, const HomeLayoutScreen());
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
              padding: const EdgeInsets.only(
                  bottom: 20.0, right: 20.0, left: 20.0),
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
                  verticalLargeSpace,
                  ConditionalBuilder(
                    condition: state is! AppChangeLocationLoadingState,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            AppCubit.get(context).saveExtraLocation(
                                extraCountryId1: widget.countryId,
                                extraCityId1: widget.cityId,
                                extraBranchId1: AppCubit.get(context)
                                    .branchModel!
                                    .data![index]
                                    .id,
                                extraBranchTitle1: AppCubit.get(context)
                                    .branchModel!
                                    .data![index]
                                    .title, extraBranchIndex1: index);
                            AppCubit.get(context).changeLocation(
                                countryId: widget.countryId,
                                cityId: widget.cityId,
                                branchId: AppCubit.get(context)
                                    .branchModel!
                                    .data![index]
                                    .id);
                          },
                          child: RegionCard(
                            title: cubit.branchModel!.data![index].title,
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            verticalSmallSpace,
                        itemCount: cubit.branchModel?.data?.length ?? 0,
                      ),
                    ),
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
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
