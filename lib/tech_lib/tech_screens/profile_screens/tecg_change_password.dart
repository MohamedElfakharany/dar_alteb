import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class TechChangePasswordScreen extends StatefulWidget {
  const TechChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<TechChangePasswordScreen> createState() => _TechChangePasswordScreenState();
}

class _TechChangePasswordScreenState extends State<TechChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final _focusNodes =
  Iterable<int>.generate(3).map((_) => FocusNode()).toList();

  // regular expression to check if string
  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double passwordStrength = 0;

  // 0: No password
  // 1/4: Weak
  // 2/4: Medium
  // 3/4: Strong
  //   1:   Great
  //A function that validate user entered password
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
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {
        if (state is AppTechChangePasswordSuccessState) {
          if (state.successModel.status) {
            AppTechCubit.get(context).signOut(context);
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: state.successModel.message,
              ),
            );
          }
        } else if (state is AppTechChangePasswordErrorState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                state.error.toString(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.resetTxtMain.tr(),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
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
                    verticalSmallSpace,
                    TextFormField(
                      focusNode: _focusNodes[0],
                      controller: oldPasswordController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            AppTechCubit.get(context)
                                .resetChangePasswordVisibility();
                          },
                          icon: Icon(AppTechCubit.get(context).resetSufIcon),
                          color: mainColor,
                        ),
                        label: Text(LocaleKeys.TxtFieldOldPassword.tr()),
                        hintStyle:
                        const TextStyle(color: greyDarkColor, fontSize: 14),
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
                      obscureText: AppTechCubit.get(context).resetIsPassword,
                      obscuringCharacter: '*',
                      onChanged: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.TxtFieldOldPassword.tr();
                        }
                      },
                    ),
                    verticalSmallSpace,
                    TextFormField(
                      focusNode: _focusNodes[1],
                      controller: newPasswordController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            AppTechCubit.get(context)
                                .resetChangePasswordVisibility();
                          },
                          icon: Icon(AppTechCubit.get(context).resetSufIcon),
                          color: mainColor,
                        ),
                        label: Text(LocaleKeys.TxtFieldNewPassword.tr()),
                        hintStyle:
                        const TextStyle(color: greyDarkColor, fontSize: 14),
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
                      obscureText: AppTechCubit.get(context).resetIsPassword,
                      obscuringCharacter: '*',
                      onChanged: (value) {
                        formKey.currentState!.validate();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.TxtFieldNewPassword.tr();
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
                    verticalSmallSpace,
                    LinearProgressIndicator(
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
                    verticalSmallSpace,
                    TextFormField(
                      focusNode: _focusNodes[2],
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            AppTechCubit.get(context)
                                .resetConfirmChangePasswordVisibility();
                          },
                          icon: Icon(AppTechCubit.get(context).resetConfirmSufIcon),
                          color: mainColor,
                        ),
                        label: Text(LocaleKeys.TxtFieldConfirmPassword.tr()),
                        hintStyle:
                        const TextStyle(color: greyDarkColor, fontSize: 14),
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
                      obscureText: AppTechCubit.get(context).resetConfirmIsPassword,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.TxtFieldConfirmPassword.tr();
                        } else if (value != newPasswordController.text) {
                          return LocaleKeys.txtPasswordsNotMatch.tr();
                        }
                      },
                    ),
                    verticalSmallSpace,
                    ConditionalBuilder(
                      condition: state is! AppTechChangePasswordLoadingState,
                      builder: (context) => GeneralButton(
                        title: LocaleKeys.BtnReset.tr(),
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            AppTechCubit.get(context).changePassword(
                              oldPassword: oldPasswordController.text,
                              newPassword: newPasswordController.text,
                            );
                          }
                        },
                      ),
                      fallback: (context) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
