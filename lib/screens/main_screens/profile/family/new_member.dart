// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../cubit/states.dart';

class NewMemberScreen extends StatefulWidget {
  const NewMemberScreen({Key? key}) : super(key: key);

  @override
  State<NewMemberScreen> createState() => _NewMemberScreenState();
}

class _NewMemberScreenState extends State<NewMemberScreen> {
  var userNameController = TextEditingController();
  var mobileNumberController = TextEditingController();
  var birthdayController = TextEditingController();
  var nationalCodeController = TextEditingController();
  String? nationalCodeValue;
  String? relationValue;

  var formKey = GlobalKey<FormState>();

  final _focusNodes =
      Iterable<int>.generate(4).map((_) => FocusNode()).toList();

  @override
  void initState() {
    super.initState();
    nationalCodeController.text = '966';
    Timer(const Duration(milliseconds: 0), () async {
      AppCubit.get(context).getRelations();
    });
  }

  Gender gender = Gender.Male;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreateMemberSuccessState) {
          if (state.successModel.status) {
            Navigator.pop(context);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(state.successModel.message),
                );
              },
            );
          }
        } else if (state is AppCreateMemberErrorState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(state.error.toString()),
              );
            },
          );
        }
      },
      builder: (context, state) {
        var memberImage = AppCubit.get(context).memberImage;
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtNewMember.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetRelationsLoadingState,
            builder: (context) => Padding(
              padding:
                  const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
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
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: memberImage == null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          'https://hq.orcav.com/assets/default.png',
                                      placeholder: (context, url) =>
                                          const SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Center(
                                            child: CircularProgressIndicator.adaptive()),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      width: 100,
                                      height: 100,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(83),
                                      child: Image.file(
                                        memberImage,
                                        height: 140,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      )),
                            ),
                            InkWell(
                              onTap: () {
                                AppCubit.get(context).getMemberImage();
                              },
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                color: whiteColor.withOpacity(0.5),
                                size: 80,
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalMediumSpace,
                      textLabel(title: LocaleKeys.txtFieldName.tr()),
                      verticalSmallSpace,
                      DefaultFormField(
                        height: 90,
                        focusNode: _focusNodes[0],
                        controller: userNameController,
                        type: TextInputType.text,
                        label: LocaleKeys.txtFieldName.tr(),
                        onTap: () {},
                        validatedText: LocaleKeys.txtFieldName.tr(),
                      ),
                      verticalSmallSpace,
                      textLabel(title: LocaleKeys.txtFieldDateOfBirth.tr()),
                      verticalSmallSpace,
                      DefaultFormField(
                        controller: birthdayController,
                        focusNode: _focusNodes[1],
                        type: TextInputType.none,
                        label: LocaleKeys.txtFieldDateOfBirth.tr(),
                        validatedText: LocaleKeys.txtFieldDateOfBirth.tr(),
                        readOnly: true,
                        onTap: () {
                          showDatePicker(
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            context: context,
                            initialDate: DateTime?.now(),
                            firstDate: DateTime.parse('1950-01-01'),
                            lastDate: DateTime?.now(),
                          ).then((value) {
                            if (value != null) {
                              if (value.day <= 9) {
                                day = '0${value.day}';
                              } else {
                                day = value.day;
                              }

                              if (value.month <= 9) {
                                month = '0${value.month}';
                              } else {
                                month = value.month;
                              }

                              birthdayController.text =
                                  '${value.year}-$month-$day';
                              if (kDebugMode) {
                                print(birthdayController.text);
                              }
                            }
                            //     DateFormat.yMd().format(value!);
                          }).catchError((error) {
                            if (kDebugMode) {
                              print('error in fetching date');
                              print(error.toString());
                            }
                          });
                        },
                        suffixIcon: Icons.calendar_month,
                        suffixPressed: (){
                          showDatePicker(
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            context: context,
                            initialDate: DateTime?.now(),
                            firstDate: DateTime.parse('1950-01-01'),
                            lastDate: DateTime?.now(),
                          ).then((value) {
                            if (value != null) {
                              if (value.day <= 9) {
                                day = '0${value.day}';
                              } else {
                                day = value.day;
                              }

                              if (value.month <= 9) {
                                month = '0${value.month}';
                              } else {
                                month = value.month;
                              }

                              birthdayController.text =
                              '${value.year}-$month-$day';
                              if (kDebugMode) {
                                print(birthdayController.text);
                              }
                            }
                            //     DateFormat.yMd().format(value!);
                          }).catchError((error) {
                            if (kDebugMode) {
                              print('error in fetching date');
                              print(error.toString());
                            }
                          });
                        },
                      ),
                      verticalSmallSpace,
                      textLabel(title: LocaleKeys.txtRelationship.tr()),
                      verticalSmallSpace,
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null) {
                              return LocaleKeys.txtRelationship.tr();
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsetsDirectional.only(
                                start: 20.0, end: 10.0),
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle:
                                TextStyle(color: Color(0xFF4F4F4F)),
                            label: Text(
                              LocaleKeys.txtRelationship.tr(),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: mainColor,
                              ),
                            ),
                          ),
                          isExpanded: true,
                          iconSize: 35,
                          items: AppCubit.get(context)
                              .relationsName
                              .map(buildMenuItem)
                              .toList(),
                          onChanged: (value) {
                            setState(() => relationValue = value);
                            AppCubit.get(context)
                                .selectRelationId(relationName: relationValue!);
                            if (kDebugMode) {
                              print(
                                  'AppCubit.get(context).relationIdList : ${AppCubit.get(context).relationIdList}');
                            }
                          },
                          onSaved: (v) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      verticalSmallSpace,
                      textLabel(title: LocaleKeys.txtFieldMobile.tr()),
                      verticalSmallSpace,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GeneralNationalityCode(
                              canSelect: true,
                                controller: nationalCodeController),
                          ),
                          horizontalMiniSpace,
                          Expanded(
                            flex: 3,
                            child: DefaultFormField(
                              height: 90,
                              focusNode: _focusNodes[3],
                              controller: mobileNumberController,
                              type: TextInputType.number,
                              label: LocaleKeys.txtFieldMobile.tr(),
                              onTap: () {},
                              validatedText:
                                  LocaleKeys.txtFieldDateOfBirth.tr(),
                            ),
                          ),
                        ],
                      ),
                      verticalMediumSpace,
                      textLabel(title: LocaleKeys.txtFieldGender.tr()),
                      verticalSmallSpace,
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
                        linearGradient: blueGreenGradient.scale(0.2),
                        padding: const EdgeInsets.all(3),
                        size: 120,
                        //default : 120
                        selectedGender: gender,
                        femaleImage:
                            const AssetImage('assets/images/female.jpg'),
                        maleImage: const AssetImage('assets/images/male.jpg'),
                        onChanged: (Gender? value) {
                          if (value != null) {
                            gender = value;
                            if (kDebugMode) {
                              print(value.index);
                            }
                          }
                        },
                      ),
                      verticalSmallSpace,
                      ConditionalBuilder(
                        condition: state is! AppCreateMemberLoadingState,
                        builder: (context) => GeneralButton(
                          title: LocaleKeys.BtnSaveChanges.tr(),
                          onPress: () {
                            if (formKey.currentState!.validate()) {
                              String mobileText = removeZeroMobile(number: mobileNumberController.text);
                              AppCubit.get(context).createMember(
                                name: userNameController.text,
                                gender: gender.name,
                                birthday: birthdayController.text,
                                phone: mobileText,
                                profile: memberImage == null
                                    ? ''
                                    : 'https://hq.orcav.com/assets/${Uri.file(memberImage.path).pathSegments.last}',
                                relationId:
                                    AppCubit.get(context).relationIdList!,
                                phoneCode: '+${nationalCodeController.text}',
                              );
                            }
                          },
                        ),
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      verticalSmallSpace,
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
      },
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item,style: titleSmallStyle,),
      );
}
