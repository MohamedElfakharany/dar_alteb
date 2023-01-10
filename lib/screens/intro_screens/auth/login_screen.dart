import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/auth/register/select_country_screen.dart';
import 'package:dar_elteb/screens/intro_screens/auth/register/sign_up_screen.dart';
import 'package:dar_elteb/screens/intro_screens/reset_password/forget_password_screen.dart';
import 'package:dar_elteb/screens/intro_screens/auth/verification_screen.dart';
import 'package:dar_elteb/screens/main_screens/home_layout_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/tech_lib/tech_home_layout.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  var nationalCodeController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  final _focusNodes =
      Iterable<int>.generate(2).map((_) => FocusNode()).toList();

  saveExtraToken(
      {required String extraToken1,
      required String type1,
      required int verified1}) async {
    (await SharedPreferences.getInstance()).setString('token', extraToken1);
    (await SharedPreferences.getInstance()).setString('type', type1);
    (await SharedPreferences.getInstance()).setInt('verified', verified1);
    token = extraToken1;
    verified = verified1;
    type = type1;
    if (kDebugMode) {
      print('token: $token');
    }
  }

  bool isLoading = false;

  int branchIndex = 0;

  @override
  void initState(){
    nationalCodeController.text = '966';
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        if (state is AppLoginSuccessState) {
          if (state.userResourceModel.status) {
            if (state.userResourceModel.data!.isVerified == 0) {
              saveExtraToken(
                extraToken1: state.userResourceModel.extra?.token,
                verified1: state.userResourceModel.data?.isVerified,
                type1: state.userResourceModel.data?.type,
              );
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
            } else if (state.userResourceModel.data!.isVerified == 1) {
              if (state.userResourceModel.data?.type == 'Technical') {
                saveExtraToken(
                  extraToken1: state.userResourceModel.extra?.token,
                  verified1: state.userResourceModel.data?.isVerified,
                  type1: state.userResourceModel.data?.type,
                );
                navigateAndFinish(context, const TechHomeLayoutScreen());
              } else {
                saveExtraToken(
                  extraToken1: state.userResourceModel.extra?.token,
                  verified1: state.userResourceModel.data?.isVerified,
                  type1: state.userResourceModel.data?.type,
                );
                if (state.userResourceModel.data!.isCompleted == 0) {
                  AppCubit.get(context).getCountry();
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: const SelectCountryScreen(),
                    ),
                  );
                } else {
                  AppCubit.get(context).dataSaving(
                    extraTokenSave: state.userResourceModel.extra?.token,
                    isVerifiedSave: state.userResourceModel.data?.isVerified,
                    countryId: state.userResourceModel.data!.country!.id,
                    cityId: state.userResourceModel.data!.city!.id,
                    branchId: state.userResourceModel.data!.branch!.id,
                    extraBranchTitle1:
                        state.userResourceModel.data!.branch!.title,
                    type: state.userResourceModel.data!.type,
                    extraBranchIndex1: 0,
                  );
                  navigateAndFinish(
                    context,
                    const HomeLayoutScreen(),
                  );
                }
              }
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // title: Text(state.userResourceModel.message),
                    content: Text(
                      LocaleKeys.txtLoginError.tr(),
                    ),
                  );
                },
              );
            }
          }
        }
        if (state is AppLoginErrorState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // title: Text(state.error.toString()),
                content: Text(
                  LocaleKeys.txtLoginError.tr(),
                ),
              );
            },
          );
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
              config: KeyboardActionsConfig(
                // Define ``defaultDoneWidget`` only once in the config
                defaultDoneWidget: doneKeyboard(),
                actions: _focusNodes
                    .map((focusNode) =>
                        KeyboardActionsItem(focusNode: focusNode))
                    .toList(),
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  verticalMediumSpace,
                  Center(
                    child: Image.asset(
                      appLogo,
                      width: 150,
                      height: 125,
                    ),
                  ),
                  verticalMiniSpace,
                  Center(
                    child: Text(
                      LocaleKeys.loginTxtMain.tr(),
                      style: titleStyle.copyWith(
                          fontSize: 30.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  verticalMiniSpace,
                  Center(
                    child: Text(
                      LocaleKeys.loginTxtSecondary.tr(),
                      style: subTitleSmallStyle,
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
                            focusNode: _focusNodes[0],
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
                  verticalMiniSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DefaultFormField(
                      height: 90,
                      focusNode: _focusNodes[1],
                      controller: passwordController,
                      type: TextInputType.text,
                      validatedText: LocaleKeys.txtFieldPassword.tr(),
                      obscureText: cubit.loginIsPassword,
                      suffixIcon: cubit.loginSufIcon,
                      label: LocaleKeys.txtFieldPassword.tr(),
                      suffixPressed: () {
                        cubit.loginChangePasswordVisibility();
                      },
                      onTap: () {},
                    ),
                  ),
                  // verticalMiniSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: ForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.BtnForgetPassword.tr(),
                          style: subTitleSmallStyle,
                        ),
                      ),
                      horizontalMiniSpace,
                    ],
                  ),
                  ConditionalBuilder(
                    condition: state is! AppLoginLoadingState,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GeneralButton(
                        title: LocaleKeys.BtnSignIn.tr(),
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            String mobileText = removeZeroMobile(number: mobileController.text);
                            isVisitor = false;
                            cubit.login(
                              mobile: mobileText,
                              password: passwordController.text,
                              phoneCode: nationalCodeController.text,
                              deviceTokenLogin: deviceToken!,
                            );
                          }
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
                        LocaleKeys.loginTxtDontHaveAccount.tr(),
                        style: subTitleSmallStyle,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.registerTxtMain.tr(),
                          style: titleSmallStyle.copyWith(color: mainColor),
                        ),
                      ),
                    ],
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
