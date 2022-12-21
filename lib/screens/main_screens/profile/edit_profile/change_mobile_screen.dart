// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/profile/edit_profile/verification_change_mobile.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ChangeMobileScreen extends StatelessWidget {
  ChangeMobileScreen({Key? key}) : super(key: key);
  final mobileController = TextEditingController();
  final nationalCodeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        if (state is AppCreateTokenSuccessState) {
          if (state.createTokenModel.status == true) {
            Navigator.push(
              context,
              FadeRoute(
                page: VerificationChangeMobileScreen(
                  phoneCode: nationalCodeController.text,
                  mobileNumber: mobileController.text.toString(),
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(
                  state.createTokenModel.message,
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
        backgroundColor: whiteColor,
        appBar: GeneralAppBar(
          title: '',
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              verticalMiniSpace,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    LocaleKeys.resetEnterMobile.tr(),
                    style: titleSmallStyle.copyWith(
                        fontWeight: FontWeight.normal, color: greyLightColor),
                  ),
                ),
              ),
              verticalMiniSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GeneralNationalityCode(
                        canSelect: true,
                        controller: nationalCodeController,
                      ),
                    ),
                    horizontalMiniSpace,
                    Expanded(
                      flex: 3,
                      child: DefaultFormField(
                        height: 90,
                        controller: mobileController,
                        type: TextInputType.phone,
                        validatedText: LocaleKeys.txtFieldMobile.tr(),
                        label: LocaleKeys.txtFieldMobile.tr(),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              verticalMediumSpace,
              ConditionalBuilder(
                condition: state is! AppCreateTokenLoadingState,
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GeneralButton(
                    title: LocaleKeys.BtnContinue.tr(),
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          FadeRoute(
                            page: VerificationChangeMobileScreen(
                              mobileNumber: mobileController.text,
                              phoneCode: nationalCodeController.text,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}
