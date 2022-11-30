// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/auth/login_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({
    Key? key,
    required this.resetToken,
  }) : super(key: key);

  String? resetToken;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final _focusNodes =
      Iterable<int>.generate(2).map((_) => FocusNode()).toList();

  // 0: No password
  // 1/4: Weak
  // 2/4: Medium
  // 3/4: Strong
  //   1:   Great
  //A function that validate user entered password

  // regular expression to check if string
  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double passwordStrength = 0;

  bool validatePassword(String pass) {
    String password = pass.trim();
    if (password.isEmpty) {
      setState(() {
        passwordStrength = 0;
      });
    } else if (password.length < 6) {
      setState(() {
        passwordStrength = 1 / 4;
      });
    } else if (password.length < 8) {
      setState(() {
        passwordStrength = 2 / 4;
      });
    } else {
      if (passValid.hasMatch(password)) {
        setState(() {
          passwordStrength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          passwordStrength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppResetPasswordSuccessState) {
          if (state.resetPasswordModel.status) {
            AppCubit.get(context).verify().then((v) {
              if (state is AppGetVerifySuccessState) {
                if (state.resetPasswordModel.status) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      FadeRoute(
                        page: const LoginScreen(),
                      ),
                      (route) => false);
                }
              }
            });
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(content: Text(state.resetPasswordModel.message)));
          }
        }
      },
      builder: (context, state) {
        if (kDebugMode) {
          print('widget.resetToken : ${widget.resetToken}');
        }
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: GeneralAppBar(
            title: '',
          ),
          body: Form(
            key: formKey,
            child: KeyboardActions(
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              config: KeyboardActionsConfig(
                // Define ``defaultDoneWidget`` only once in the config
                defaultDoneWidget: doneKeyboard(),
                actions: _focusNodes
                    .map((focusNode) =>
                        KeyboardActionsItem(focusNode: focusNode))
                    .toList(),
              ),
              child: ListView(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        LocaleKeys.resetTxtMain.tr(),
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
                        LocaleKeys.resetTxtForth.tr(),
                        style: titleSmallStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: greyLightColor),
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: whiteColor,
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 10), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 4),
                      child: TextFormField(
                        focusNode: _focusNodes[0],
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              AppCubit.get(context)
                                  .resetChangePasswordVisibility();
                            },
                            icon: Icon(AppCubit.get(context).resetSufIcon),
                            color: mainColor,
                          ),
                          label: Text(LocaleKeys.txtFieldPassword.tr()),
                          hintStyle: const TextStyle(
                              color: greyDarkColor, fontSize: 14),
                          labelStyle: const TextStyle(
                              // color: isClickable ? Colors.grey[400] : blueColor,
                              color: greyDarkColor,
                              fontSize: 14),
                          fillColor: Colors.white,
                          filled: true,
                          errorStyle: const TextStyle(color: redColor),
                          // floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: const EdgeInsetsDirectional.only(
                              start: 20.0, end: 10.0, bottom: 15.0, top: 15.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: greyExtraLightColor,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                            color: mainLightColor,
                            fontSize: 18,
                            fontFamily: fontFamily),
                        obscureText: AppCubit.get(context).resetIsPassword,
                        obscuringCharacter: '*',
                        onChanged: (value) {
                          formKey.currentState!.validate();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocaleKeys.txtFieldPassword.tr();
                          } else {
                            //call function to check password
                            bool result = validatePassword(value);
                            if (result) {
                              // create account event
                              return null;
                            } else {
                              return LocaleKeys.passwordConditions.tr();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: LinearProgressIndicator(
                      value: passwordStrength,
                      backgroundColor: Colors.grey[300],
                      minHeight: 5,
                      color: passwordStrength <= 1 / 4
                          ? Colors.red
                          : passwordStrength == 2 / 4
                              ? Colors.yellow
                              : passwordStrength == 3 / 4
                                  ? Colors.blue
                                  : Colors.green,
                    ),
                  ),
                  verticalMiniSpace,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: whiteColor,
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 10), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 4),
                      child: TextFormField(
                        focusNode: _focusNodes[1],
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              AppCubit.get(context)
                                  .resetConfirmChangePasswordVisibility();
                            },
                            icon:
                                Icon(AppCubit.get(context).resetConfirmSufIcon),
                            color: mainColor,
                          ),
                          label: Text(LocaleKeys.TxtFieldConfirmPassword.tr()),
                          hintStyle: const TextStyle(
                              color: greyDarkColor, fontSize: 14),
                          labelStyle: const TextStyle(
                              // color: isClickable ? Colors.grey[400] : blueColor,
                              color: greyDarkColor,
                              fontSize: 14),
                          fillColor: Colors.white,
                          filled: true,
                          errorStyle: const TextStyle(color: redColor),
                          // floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: const EdgeInsetsDirectional.only(
                              start: 20.0, end: 10.0, bottom: 15.0, top: 15.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: greyExtraLightColor,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                            color: mainLightColor,
                            fontSize: 18,
                            fontFamily: fontFamily),
                        obscureText:
                            AppCubit.get(context).resetConfirmIsPassword,
                        obscuringCharacter: '*',
                        onChanged: (value) {
                          formKey.currentState!.validate();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocaleKeys.TxtFieldConfirmPassword.tr();
                          } else if (value != passwordController.text) {
                            return LocaleKeys.txtPasswordsNotMatch.tr();
                          }
                        },
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  ConditionalBuilder(
                    condition: state is! AppResetPasswordLoadingState,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GeneralButton(
                        title: LocaleKeys.BtnReset.tr(),
                        onPress: () {
                          if (formKey.currentState!.validate()) {

                            AppCubit.get(context).resetPassword(
                                resetToken: widget.resetToken,
                                newPassword: passwordController.text);
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
      },
    );
  }
}
