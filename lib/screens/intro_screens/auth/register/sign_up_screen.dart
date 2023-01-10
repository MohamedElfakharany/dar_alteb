// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable, unnecessary_import

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/auth/login_screen.dart';
import 'package:dar_elteb/screens/intro_screens/auth/verification_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userNameController = TextEditingController();

  final mobileController = TextEditingController();

  final nationalCodeController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final nationalIdController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final _focusNodes =
      Iterable<int>.generate(5).map((_) => FocusNode()).toList();

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

  // bool isPasswordTyping = false;

  @override
  void initState (){
    AppCubit.get(context).getTerms();
    nationalCodeController.text = '966';
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        if (state is AppRegisterSuccessState) {
          if (state.userResourceModel.status) {
            token = state.userResourceModel.extra!.token;
            String mobileText = removeZeroMobile(number: mobileController.text);
            await Navigator.push(
              context,
              FadeRoute(
                page: VerificationScreen(
                  phoneCode: nationalCodeController.text,
                  mobileNumber: mobileText,
                ),
              ),
            );
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(state.userResourceModel.message),
                    content: Text(LocaleKeys.txtLoginAgain.tr()),
                  );
                });
          }
        } else if (state is AppRegisterErrorState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(LocaleKeys.txtLoginAgain.tr()),
                );
              });
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
            child: KeyboardActions(
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              bottomAvoiderScrollPhysics: const BouncingScrollPhysics(),
              config: KeyboardActionsConfig(
                // Define ``defaultDoneWidget`` only once in the config
                defaultDoneWidget: doneKeyboard(),
                actions: _focusNodes
                    .map((focusNode) =>
                        KeyboardActionsItem(focusNode: focusNode))
                    .toList(),
              ),
              child: ConditionalBuilder(
                condition: state is! AppGetTermsLoadingState,
                builder: (context) => Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          LocaleKeys.BtnSignUp.tr(),
                          style: titleStyle.copyWith(
                              fontSize: 35.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    verticalMiniSpace,
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          LocaleKeys.registerTxtSecondary.tr(),
                          style: titleStyle.copyWith(
                              fontWeight: FontWeight.normal,
                              color: greyLightColor),
                        ),
                      ),
                    ),
                    verticalMiniSpace,
                    // if (isPasswordTyping == false)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: DefaultFormField(
                          height: 90,
                          focusNode: _focusNodes[0],
                          controller: userNameController,
                          type: TextInputType.text,
                          validatedText: LocaleKeys.txtFieldName.tr(),
                          label: LocaleKeys.txtFieldName.tr(),
                          onTap: () {},
                        ),
                      ),
                    // if (isPasswordTyping == false)
                      verticalMiniSpace,
                    // if (isPasswordTyping == false)
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
                                focusNode: _focusNodes[1],
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
                    // if (isPasswordTyping == false)
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
                        decoration: const BoxDecoration(
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
                          // textInputAction: TextInputAction.next,
                          focusNode: _focusNodes[2],
                          onEditingComplete: () {
                            // isPasswordTyping = false;
                          },
                          onFieldSubmitted: (value) {
                            // isPasswordTyping = false;
                          },
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
                          style: TextStyle(
                              color: mainLightColor,
                              fontSize: 18,
                              fontFamily: fontFamily),
                          obscureText: AppCubit.get(context).resetIsPassword,
                          obscuringCharacter: '*',
                          onChanged: (value) {
                            // isPasswordTyping = true;
                            validatePassword(value);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocaleKeys.txtFieldPassword.tr();
                            }else if (value.length < 8 ){
                              return LocaleKeys.txtPasswordValidate.tr();
                            }
                          },
                        ),
                      ),
                    ),
                    verticalMiniSpace,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Container(
                        decoration: const BoxDecoration(
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
                          // textInputAction: TextInputAction.next,
                          focusNode: _focusNodes[3],
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
                          style: TextStyle(
                              color: mainLightColor,
                              fontSize: 18,
                              fontFamily: fontFamily),
                          obscureText:
                          AppCubit.get(context).resetConfirmIsPassword,
                          obscuringCharacter: '*',
                          onChanged: (value) {
                            // formKey.currentState!.validate();
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: DefaultFormField(
                        height: 90,
                        focusNode: _focusNodes[4],
                        controller: nationalIdController,
                        type: TextInputType.number,
                        label: LocaleKeys.txtFieldIdNumber.tr(),
                        onTap: () {},
                        validatedText: LocaleKeys.txtFieldIdNumber.tr(),
                      ),
                    ),
                    verticalMiniSpace,
                    Column(
                      children: [
                        Text(
                          LocaleKeys.txtAgree.tr(),
                          style: subTitleSmallStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Text(
                                LocaleKeys.txtTitleOfOurTermsOfService.tr(),
                                style: const TextStyle(color: mainColor),
                              ),
                              onPressed: () {
                                showPopUp(
                                  context,
                                  Container(
                                    height: 500,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 30.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        verticalMediumSpace,
                                        Padding(
                                          padding:
                                          const EdgeInsetsDirectional.only(
                                              start: 20.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                LocaleKeys
                                                    .txtTitleOfOurTermsOfService
                                                    .tr(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: mainColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              verticalMiniSpace,
                                              SizedBox(
                                                height: 350.0,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  physics:
                                                  const BouncingScrollPhysics(),
                                                  child: Text(
                                                    AppCubit.get(context).termsModel?.data?.terms ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: subTitleSmallStyle,
                                                  ),
                                                ),
                                              ),
                                              verticalMiniSpace,
                                              GeneralButton(
                                                title: LocaleKeys.BtnOk.tr(),
                                                onPress: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            // const Text(
                            //   'And',
                            //   style: subTitleSmallStyle,
                            // ),
                            TextButton(
                              onPressed: () {
                                showPopUp(
                                  context,
                                  Container(
                                    height: 500,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 30.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        verticalMediumSpace,
                                        Padding(
                                          padding:
                                          const EdgeInsetsDirectional.only(
                                              start: 20.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                LocaleKeys
                                                    .txtTitleOfOurPrivacyPolicy
                                                    .tr(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: mainColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              verticalMiniSpace,
                                              SizedBox(
                                                height: 350.0,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  physics:
                                                  const BouncingScrollPhysics(),
                                                  child: Text(
                                                    AppCubit.get(context).termsModel?.data?.privacy ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: subTitleSmallStyle,
                                                  ),
                                                ),
                                              ),
                                              verticalMiniSpace,
                                              GeneralButton(
                                                title: LocaleKeys.BtnOk.tr(),
                                                onPress: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                LocaleKeys.txtTitleOfOurPrivacyPolicy.tr(),
                                style: const TextStyle(color: mainColor),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    horizontalMiniSpace,
                    ConditionalBuilder(
                      condition: state is! AppRegisterLoadingState,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GeneralButton(
                          title: LocaleKeys.BtnSignUp.tr(),
                          onPress: () {
                            if (formKey.currentState!.validate()) {
                              String mobileText = removeZeroMobile(number: mobileController.text);
                              cubit.register(
                                name: userNameController.text,
                                nationalID: nationalIdController.text,
                                password: passwordController.text,
                                mobile: mobileText,
                                phoneCode: nationalCodeController.text,
                                deviceTokenLogin: deviceToken!,
                              );
                            }
                            isVisitor = false;
                          },
                        ),
                      ),
                      fallback: (context) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                    ),
                    verticalMediumSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.registerTxtHaveAccount.tr(),
                          style: subTitleSmallStyle,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              FadeRoute(
                                page: const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            LocaleKeys.BtnSignIn.tr(),
                            style: titleSmallStyle.copyWith(color: mainColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                fallback: (context) => const Center(child: CircularProgressIndicator.adaptive(),),
              ),
            ),
          ),
        );
      },
    );
  }
}
