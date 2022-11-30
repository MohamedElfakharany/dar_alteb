// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/reset_password/verification_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key, this.isChangeMobile}) : super(key: key);
  bool? isChangeMobile = false;
  final mobileController = TextEditingController();
  final nationalCodeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        if (state is AppCreateTokenSuccessState) {
          if (state.createTokenModel.status) {
            Navigator.push(
              context,
              FadeRoute(
                page: VerificationScreen(
                  phoneCode: nationalCodeController.text,
                  resetToken: state.createTokenModel.data!.resetToken,
                  isRegister: false,
                  mobileNumber: mobileController.text.toString(),
                  isChangeMobile: false,
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
        } else {}
      },
      builder: (context, state) => Scaffold(
        backgroundColor: whiteColor,
        appBar: GeneralAppBar(
          title: '',
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              if (isChangeMobile != true)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      LocaleKeys.forgetTxtMain.tr(),
                      style: titleStyle.copyWith(
                          fontSize: 30.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
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
                        if (isChangeMobile == false) {
                          AppCubit.get(context)
                              .createToken(mobile: mobileController.text, phoneCode: nationalCodeController.text);
                        } else {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: VerificationScreen(
                                  mobileNumber: mobileController.text,
                                  phoneCode: nationalCodeController.text,
                                  isRegister: false,
                                  isChangeMobile: true),
                            ),
                          );
                        }
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
      ),
    );
  }
}
