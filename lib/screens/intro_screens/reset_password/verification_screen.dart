// // ignore_for_file: must_be_immutable, use_build_context_synchronously
// import 'dart:async';
// import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dar_elteb/cubit/cubit.dart';
// import 'package:dar_elteb/cubit/states.dart';
// import 'package:dar_elteb/screens/intro_screens/auth/register/select_country_screen.dart';
// import 'package:dar_elteb/screens/intro_screens/reset_password/reset_password_screen.dart';
// import 'package:dar_elteb/shared/components/general_components.dart';
// import 'package:dar_elteb/shared/constants/colors.dart';
// import 'package:dar_elteb/shared/constants/general_constants.dart';
// import 'package:dar_elteb/translations/locale_keys.g.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class VerificationScreen extends StatefulWidget {
//   VerificationScreen({
//     Key? key,
//     required this.mobileNumber,
//     required this.phoneCode,
//     this.isRegister,
//     this.isChangeMobile,
//     this.resetToken,
//   }) : super(key: key);
//   bool? isRegister;
//   bool? isChangeMobile;
//   String? resetToken;
//   String phoneCode = "";
//   String mobileNumber = "";
//
//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }
//
// class _VerificationScreenState extends State<VerificationScreen> {
//   final codeController = TextEditingController();
//   var formKey = GlobalKey<FormState>();
//
//   bool isFirst = true;
//
//   Future<void> verify() async {
//     PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
//       verificationId: AppCubit.get(context).verificationId.toString(),
//       smsCode: codeController.text,
//     );
//     await signInWithPhoneAuthCredential(phoneAuthCredential);
//   }
//
//   Future<void> signInWithPhoneAuthCredential(
//       PhoneAuthCredential phoneAuthCredential) async {
//     try {
//       final authCredential =
//           await AppCubit.get(context).auth.signInWithCredential(phoneAuthCredential);
//       if (authCredential.user != null) {
//         if (widget.isRegister == true && widget.isChangeMobile == false) {
//           await AppCubit.get(context).verify().then((v) {
//             AppCubit.get(context).getCountry().then((v) {
//               Navigator.push(
//                   context, FadeRoute(page: const SelectCountryScreen()));
//             });
//           });
//         } else if (widget.isRegister == false &&
//             widget.isChangeMobile == false) {
//           Navigator.push(
//             context,
//             FadeRoute(
//               page: ResetPasswordScreen(resetToken: widget.resetToken),
//             ),
//           );
//         } else if (widget.isRegister == false &&
//             widget.isChangeMobile == true) {
//           AppCubit.get(context).changeNumber(
//               phone: widget.mobileNumber, phoneCode: '+${widget.phoneCode}');
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           if (kDebugMode) {
//             print (e.credential?.asMap());
//           }
//           return AlertDialog(
//             content: Text(
//               e.code,
//             ),
//           );
//         },
//       );
//       if (kDebugMode) {
//         print("catch");
//       }
//     }
//   }
//
//   saveVerified({required int verified1}) async {
//     (await SharedPreferences.getInstance()).setInt('verified', verified1);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (isFirst) {
//       isFirst = false;
//     }
//     AppCubit.get(context).fetchOtp(number: widget.mobileNumber, phoneCode: '+${widget.phoneCode}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (kDebugMode) {
//       print(widget.mobileNumber.toString());
//       print('AppCubit.get(context).verificationId : $AppCubit.get(context).verificationId');
//     }
//     return BlocConsumer<AppCubit, AppStates>(
//       listener: (context, state) async {
//         if (state is AppGetVerifySuccessState) {
//           if (state.successModel.status) {
//             saveVerified(verified1: 1);
//             AppCubit.get(context).getCountry().then(
//                   (value) => {
//                     Navigator.push(
//                       context,
//                       FadeRoute(
//                         page: const SelectCountryScreen(),
//                       ),
//                     ),
//                   },
//                 );
//           } else {
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   content: Text(state.successModel.message),
//                 );
//               },
//             );
//           }
//         } else if (state is AppGetVerifyErrorState) {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 content: Text(state.error),
//               );
//             },
//           );
//         }
//         if (state is AppChangeNumberSuccessState) {
//           if (state.successModel.status) {
//             AppCubit.get(context).signOut(context);
//           } else {
//             Navigator.pop(context);
//             Navigator.pop(context);
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   content: Text(state.successModel.message),
//                 );
//               },
//             );
//           }
//         } else if (state is AppChangeNumberErrorState) {
//           Navigator.pop(context);
//           Navigator.pop(context);
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 content: Text(state.error),
//               );
//             },
//           );
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: whiteColor,
//           appBar: GeneralAppBar(
//             title: '',
//           ),
//           body: Form(
//             key: formKey,
//             child: ConditionalBuilder(
//               condition: state is! AppCreateTokenLoadingState,
//               builder: (context) => ListView(
//                 children: [
//                   Align(
//                     alignment: AlignmentDirectional.centerStart,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Row(
//                         children: [
//                           Text(
//                             LocaleKeys.verifyTxtMain.tr(),
//                             style: titleStyle.copyWith(
//                                 fontSize: 30.0, fontWeight: FontWeight.w600),
//                           ),
//                           horizontalLargeSpace,
//                           const Icon(
//                             Icons.email,
//                             color: greyLightColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   verticalMiniSpace,
//                   Align(
//                     alignment: AlignmentDirectional.centerStart,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         LocaleKeys.resetTxtThird.tr(),
//                         style: titleSmallStyle.copyWith(
//                             fontWeight: FontWeight.normal,
//                             color: greyLightColor),
//                       ),
//                     ),
//                   ),
//                   verticalMiniSpace,
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                     child: DefaultFormField(
//                       height: 90,
//                       controller: codeController,
//                       type: TextInputType.phone,
//                       validatedText: LocaleKeys.txtFieldCodeReset.tr(),
//                       label: LocaleKeys.txtFieldCodeReset.tr(),
//                       onTap: () {},
//                     ),
//                   ),
//                   verticalMediumSpace,
//                   ConditionalBuilder(
//                     condition: state is! AppGetVerifyLoadingState ||
//                         state is! AppCreateTokenLoadingState &&
//                             AppCubit.get(context).verificationId == null,
//                     builder: (context) => GeneralButton(
//                       title: LocaleKeys.BtnVerify.tr(),
//                       onPress: () {
//                         if (formKey.currentState!.validate()) {
//                           AppCubit.get(context).fetchOtp(
//                                   number: widget.mobileNumber,
//                                   phoneCode: '+${widget.phoneCode}')
//                               .then((c) {
//                           });
//                             verify();
//
//                           if (widget.isRegister == false &&
//                               widget.isChangeMobile == false){
//                           AppCubit.get(context)
//                               .createToken(
//                                   mobile: widget.mobileNumber.toString(),
//                                   phoneCode: '+${widget.phoneCode}')
//                               .then((v) {});
//                           }
//                         }
//                       },
//                     ),
//                     fallback: (context) => const Center(
//                       child: CircularProgressIndicator.adaptive(),
//                     ),
//                   ),
//                   verticalMediumSpace,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         LocaleKeys.txtDidntReseveCode.tr(),
//                         style: subTitleSmallStyle,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           codeController.text = '';
//                           AppCubit.get(context)
//                               .createToken(
//                                   mobile: widget.mobileNumber.toString(),
//                                   phoneCode: '+${widget.phoneCode}')
//                               .then((v) {
//                             AppCubit.get(context).fetchOtp(
//                                 number: widget.mobileNumber,
//                                 phoneCode: '+${widget.phoneCode}');
//                           });
//                         },
//                         child: Text(
//                           LocaleKeys.BtnResend.tr(),
//                           style: titleSmallStyle.copyWith(color: mainColor),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               fallback: (context) => const Center(
//                 child: CircularProgressIndicator.adaptive(),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/auth/register/select_country_screen.dart';
import 'package:dar_elteb/screens/intro_screens/reset_password/reset_password_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  VerificationScreen({
    Key? key,
    required this.mobileNumber,
    required this.phoneCode,
    this.isRegister,
    this.isChangeMobile,
    this.resetToken,
  }) : super(key: key);
  bool? isRegister;
  bool? isChangeMobile;
  String? resetToken;
  String phoneCode = "";
  String mobileNumber = "";
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final codeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  String? verificationId = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  Future fetchOtp(
      {required String number, required String phoneCode}) async {
    if (kDebugMode) {
      print('verificationId Sign In before : $verificationId');
    }
    await auth.verifyPhoneNumber(
      phoneNumber: '+$phoneCode$number',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((v) => {
          print(v.credential?.asMap())
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          if (kDebugMode) {
            print('The provided phone number is not valid.');
          }
        }
      },
      codeSent: (String verificationIdC, int? resendToken) async {
        verificationId = verificationIdC;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    if (kDebugMode) {
      print('verificationId Sign In after  : $verificationId');
    }
  }

  bool isFirst = true;

  Future<void> verify() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId.toString(),
      smsCode: codeController.text,
    );
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential = await auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        if (widget.isRegister == true && widget.isChangeMobile == false) {
          await AppCubit.get(context).verify().then((v) {
            AppCubit.get(context).getCountry().then((v) {
              Navigator.push(
                  context, FadeRoute(page: const SelectCountryScreen()));
            });
          });
        } else if (widget.isRegister == false &&
            widget.isChangeMobile == false) {
          Navigator.push(
            context,
            FadeRoute(
              page: ResetPasswordScreen(resetToken: widget.resetToken),
            ),
          );
        } else if (widget.isRegister == false &&
            widget.isChangeMobile == true) {
          AppCubit.get(context).changeNumber(phone: widget.mobileNumber, phoneCode: widget.phoneCode);
        }else {
          await AppCubit.get(context).verify().then((v) {
            AppCubit.get(context).getCountry().then((v) {
              Navigator.push(
                  context, FadeRoute(page: const SelectCountryScreen()));
            });
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return
            // const Center(child: CircularProgressIndicator.adaptive());
            AlertDialog(
            content: Text(
              e.code,
            ),
          );
        },
      );
      if (kDebugMode) {
        print("catch");
      }
    }
  }

  saveVerified({required int verified1}) async {
    (await SharedPreferences.getInstance()).setInt('verified', verified1);
  }

  @override
  void initState() {
    super.initState();
    if (isFirst) {
      isFirst = false;
      fetchOtp(number: widget.mobileNumber, phoneCode: widget.phoneCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.mobileNumber.toString());
      print(
          'AppCubit.get(context).verificationId : $verificationId');
    }
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        if (state is AppGetVerifySuccessState) {
          if (state.successModel.status) {
            saveVerified(verified1: 1);
            AppCubit.get(context).getCountry().then(
                  (value) => {
                Navigator.push(
                  context,
                  FadeRoute(
                    page: const SelectCountryScreen(),
                  ),
                ),
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.successModel.message),
                );
              },
            );
          }
        } else if (state is AppGetVerifyErrorState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(state.error),
              );
            },
          );
        }
        if (state is AppChangeNumberSuccessState) {
          if (state.successModel.status) {
            AppCubit.get(context).signOut(context);
          } else {
            Navigator.pop(context);
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.successModel.message),
                );
              },
            );
          }
        } else if (state is AppChangeNumberErrorState) {
          Navigator.pop(context);
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(state.error),
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
            child: ConditionalBuilder(
              condition: state is! AppCreateTokenLoadingState,
              builder: (context) => ListView(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text(
                            LocaleKeys.verifyTxtMain.tr(),
                            style: titleStyle.copyWith(
                                fontSize: 30.0, fontWeight: FontWeight.w600),
                          ),
                          horizontalLargeSpace,
                          const Icon(
                            Icons.email,
                            color: greyLightColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        LocaleKeys.resetTxtThird.tr(),
                        style: titleSmallStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: greyLightColor),
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DefaultFormField(
                      height: 90,
                      controller: codeController,
                      type: TextInputType.phone,
                      validatedText: LocaleKeys.txtFieldCodeReset.tr(),
                      label: LocaleKeys.txtFieldCodeReset.tr(),
                      onTap: () {},
                    ),
                  ),
                  verticalMediumSpace,
                  ConditionalBuilder(
                    condition: state is! AppGetVerifyLoadingState ||
                        state is! AppCreateTokenLoadingState && verificationId != null,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GeneralButton(
                        title: LocaleKeys.BtnVerify.tr(),
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            AppCubit.get(context).verify();
                            AppCubit.get(context)
                                .createToken(
                                mobile: widget.mobileNumber.toString(), phoneCode: widget.phoneCode)
                                .then((v) {
                              verify();
                            });
                          }
                        },
                      ),
                    ),
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  verticalMediumSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.txtDidntReseveCode.tr(),
                        style: subTitleSmallStyle,
                      ),
                      TextButton(
                        onPressed: () {
                          codeController.text = '';
                          AppCubit.get(context)
                              .createToken(mobile: widget.mobileNumber.toString(), phoneCode: widget.phoneCode)
                              .then((v) {
                            fetchOtp(number: widget.mobileNumber, phoneCode: widget.phoneCode);
                          });
                        },
                        child: Text(
                          LocaleKeys.BtnResend.tr(),
                          style: titleSmallStyle.copyWith(color: mainColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              fallback: (context) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
        );
      },
    );
  }
}