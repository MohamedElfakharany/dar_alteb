import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/home_layout_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class SelectGenderScreen extends StatelessWidget {
  const SelectGenderScreen(
      {Key? key,
      required this.countryId,
      required this.cityId,
      required this.branchId,
      required this.branchIndex,})
      : super(key: key);
  final int countryId;
  final int cityId;
  final int branchId;
  final int branchIndex;

  @override
  Widget build(BuildContext context) {
    Gender selectedGender = Gender.Male;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCompleteProfileSuccessState) {
          if (state.userResourceModel.status) {
            AppCubit.get(context).dataSaving(
              type: state.userResourceModel.data!.type,
              extraTokenSave: state.userResourceModel.extra?.token,
              isVerifiedSave: state.userResourceModel.data?.isVerified,
              countryId: state.userResourceModel.data!.country!.id,
              cityId: state.userResourceModel.data!.city!.id,
              branchId: state.userResourceModel.data!.branch!.id,
              extraBranchTitle1: state.userResourceModel.data!.branch!.title,
              extraBranchIndex1: branchIndex,
            );
            AppCubit.get(context).getCarouselData();
            navigateAndFinish(
              context,
              const HomeLayoutScreen(),
            );
            navigateAndFinish(context, const HomeLayoutScreen());
          }
        }
        if (isVisitor == true) {
          if (state is AppCompleteProfileSuccessState) {
            AppCubit.get(context).dataSaving(
              type: state.userResourceModel.data!.type,
              extraTokenSave: state.userResourceModel.extra?.token,
              isVerifiedSave: state.userResourceModel.data?.isVerified,
              countryId: state.userResourceModel.data!.country!.id,
              cityId: state.userResourceModel.data!.city!.id,
              branchId: state.userResourceModel.data!.branch!.id,
              extraBranchTitle1: state.userResourceModel.data!.branch!.title, extraBranchIndex1: branchIndex,
            );
            navigateAndFinish(
              context,
              const HomeLayoutScreen(),
            );
          }
          navigateAndFinish(context, const HomeLayoutScreen());
        }
      },
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
                    '${LocaleKeys.BtnSelect.tr()} ${LocaleKeys.txtFieldGender.tr()}',
                    style: titleStyle.copyWith(fontSize: 30),
                  ),
                  Text(
                    LocaleKeys.onboardingBody.tr(),
                    style: subTitleSmallStyle,
                  ),
                  verticalSmallSpace,
                  LinearProgressIndicator(
                      value: 0.9,
                      backgroundColor: greyLightColor.withOpacity(0.3),
                      color: greenColor),
                  verticalLargeSpace,
                  GenderPickerWithImage(
                    maleText: LocaleKeys.Male.tr(),
                    //default Male
                    femaleText: LocaleKeys.Female.tr(),
                    //default Female
                    selectedGenderTextStyle:
                        titleStyle.copyWith(color: greenColor),
                    verticalAlignedText: true,
                    equallyAligned: true,
                    animationDuration: const Duration(milliseconds: 300),
                    isCircular: true,
                    // default : true,
                    opacityOfGradient: 0.3,
                    linearGradient: blueGreenGradient.scale(0.3),
                    padding: const EdgeInsets.all(3),
                    size: 120,
                    //default : 120
                    femaleImage: const AssetImage('assets/images/female.jpg'),
                    maleImage: const AssetImage('assets/images/male.jpg'),

                    onChanged: (Gender? value) {
                      if (value != null) {
                        selectedGender = value;
                        if (kDebugMode) {
                          print(selectedGender);
                        }
                      }
                    },
                  ),
                  verticalSmallSpace,
                  ConditionalBuilder(
                    condition: state is! AppCompleteProfileLoadingState,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GeneralButton(
                          title: LocaleKeys.BtnSubmit.tr(),
                          onPress: () {
                            extraCountryId = countryId;
                            extraCityId = cityId;
                            extraBranchId = branchId;
                            AppCubit.get(context).completeProfile(
                              countryId: countryId,
                              cityId: cityId,
                              branchId: branchId,
                              gender: selectedGender.name,
                            );

                          }),
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
