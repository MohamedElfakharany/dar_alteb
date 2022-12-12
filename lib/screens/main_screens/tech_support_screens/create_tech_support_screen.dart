// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/profile/address_screen/address_screen.dart';
import 'package:dar_elteb/screens/main_screens/tech_support_screens/tech_support_overview_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class CreateTechSupportScreen extends StatefulWidget {
  const CreateTechSupportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateTechSupportScreen> createState() =>
      _CreateTechSupportScreenState();
}

class _CreateTechSupportScreenState extends State<CreateTechSupportScreen> {
  String? locationValue;
  String? memberValue;
  String? dateValue;
  String? timeValue;
  String? date;

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getAddress();
    AppCubit.get(context).getFamilies();
  }

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtReservationDetails.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetAddressLoadingState,
            builder: (context) => Padding(
              padding:
                  const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.txtPatient.tr(),
                      style: titleStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                    verticalMiniSpace,
                    if (AppCubit.get(context).isVisitor == true)
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        alignment: AlignmentDirectional.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.perm_identity_rounded,
                                color: greyLightColor,
                                size: 30,
                              ),
                              horizontalMiniSpace,
                              Text(
                                LocaleKeys.txtPatient.tr(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (AppCubit.get(context).isVisitor == false)
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        alignment: AlignmentDirectional.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.perm_identity_rounded,
                                color: greyLightColor,
                                size: 30,
                              ),
                              contentPadding: EdgeInsetsDirectional.only(
                                start: 20.0,
                                end: 0.0,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              errorStyle: TextStyle(color: Color(0xFF4F4F4F)),
                              border: InputBorder.none,
                            ),
                            hint: Text(LocaleKeys.TxtFieldMemberOfVisit.tr()),
                            value: memberValue,
                            isExpanded: true,
                            iconSize: 30,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: mainColor,
                            ),
                            items: AppCubit.get(context)
                                .familiesName
                                .map(buildMenuItem)
                                .toList(),
                            onChanged: (value) => setState(() {
                              memberValue = value!;
                              AppCubit.get(context).selectBranchForReservation(
                                  name: memberValue ?? '');
                            }),
                            onSaved: (v) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                    verticalMiniSpace,
                    Text(
                      LocaleKeys.TxtPopUpReservationType.tr(),
                      style: titleStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                    verticalMiniSpace,
                    Container(
                      height: 275.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultFormField(
                            controller: dateController,
                            type: TextInputType.none,
                            label: LocaleKeys.TxtFieldDateOfVisit.tr(),
                            suffixPressed: () {},
                            validatedText: LocaleKeys.TxtFieldDateOfVisit.tr(),
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime.now()
                                      .add(const Duration(days: 30)),
                                  onChanged: (date) {
                                setState(() {
                                  dateController.text =
                                      '${date.year.toString()}-${date.month.toString()}-${date.day.toString()}';
                                });
                              }, onConfirm: (date) {
                                setState(() {
                                  dateController.text =
                                      '${date.year.toString()}-${date.month.toString()}-${date.day.toString()}';
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                          ),
                          const Spacer(),
                          myHorizontalDivider(),
                          const Spacer(),
                          DefaultFormField(
                            controller: timeController,
                            type: TextInputType.none,
                            label: LocaleKeys.TxtFieldTimeOfVisit.tr(),
                            suffixPressed: () {},
                            validatedText: LocaleKeys.TxtFieldTimeOfVisit.tr(),
                            onTap: () {
                              DatePicker.showTimePicker(context,
                                  showTitleActions: true,
                                  showSecondsColumn: false, onChanged: (date) {
                                setState(() {
                                  timeController.text =
                                      '${date.hour.toString()}:${date.minute.toString()}';
                                });
                              }, onConfirm: (date) {
                                setState(() {
                                  timeController.text =
                                      '${date.hour.toString()}:${date.minute.toString()}';
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                          ),
                          const Spacer(),
                          myHorizontalDivider(),
                          const Spacer(),
                          DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return 'Location Required';
                                }
                              },
                              hint: Text(
                                LocaleKeys.TxtFieldAddressOfVisit.tr(),
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.location_on_rounded,
                                  color: greyLightColor,
                                  size: 30,
                                ),
                                contentPadding:
                                    const EdgeInsetsDirectional.only(
                                        start: 20.0,
                                        end: 0.0,
                                        bottom: 0.0,
                                        top: 10.0),
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(color: Color(0xFF4F4F4F)),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    AppCubit.get(context).getAddress();
                                    Navigator.push(
                                      context,
                                      FadeRoute(
                                        page: const AddressScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_location_alt_outlined,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                              value: locationValue,
                              isExpanded: true,
                              iconSize: 30,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: mainColor,
                              ),
                              items: AppCubit.get(context)
                                  .addressName
                                  .map(buildLocationItem)
                                  .toList(),
                              onChanged: (value) => setState(() {
                                locationValue = value;
                                AppCubit.get(context)
                                    .selectAddressId(address: locationValue!);
                              }),
                              onSaved: (v) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: TechSupportOverviewScreen(
                                addressId: AppCubit.get(context).addressIdList,
                                time: timeController.text,
                                date: dateController.text,
                                addressTitle: locationValue!,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        child: Center(
                            child: Text(
                          LocaleKeys.BtnContinue.tr(),
                          style: titleStyle.copyWith(
                              fontSize: 20.0,
                              color: whiteColor,
                              fontWeight: FontWeight.normal),
                        )),
                      ),
                    ),
                    verticalMiniSpace,
                  ],
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
        child: Row(
          children: [
            Text(item,style: titleSmallStyle,),
          ],
        ),
      );

  DropdownMenuItem<String> buildLocationItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: titleSmallStyle,
        ),
      );
}
