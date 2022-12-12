// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/test_models/offers_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/tests_model.dart';
import 'package:dar_elteb/screens/main_screens/profile/address_screen/address_screen.dart';
import 'package:dar_elteb/screens/main_screens/reservations/details_screens/home_appointments/home_reservation_overview_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class HomeReservationDetailsScreen extends StatefulWidget {
  HomeReservationDetailsScreen(
      {Key? key,
      this.offersDataModel,
      this.testsDataModel,
      required this.date,
      required this.time})
      : super(key: key);
  final String date;
  final String time;
  TestsDataModel? testsDataModel;
  OffersDataModel? offersDataModel;

  @override
  State<HomeReservationDetailsScreen> createState() =>
      _HomeReservationDetailsScreenState();
}

class _HomeReservationDetailsScreenState
    extends State<HomeReservationDetailsScreen> {
  String? locationValue;
  String? memberValue;

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getBranch(cityID: extraCityId!);
    AppCubit.get(context).getFamilies();
    AppCubit.get(context).getAddress();
  }

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        print('HomeReservationDetailsScreen');
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtReservationDetails.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetBranchesLoadingState,
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
                            value: memberValue,
                            isExpanded: true,
                            iconSize: 30,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: mainColor,
                            ),
                            hint: Text('${AppCubit.get(context).userResourceModel?.data?.name}'),
                            items: AppCubit.get(context)
                                .familiesName
                                .map(buildMenuItem)
                                .toList(),
                            onChanged: (value) => setState(() {
                              memberValue = value;
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
                      height: 150.0,
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
                          Expanded(
                            child: Row(
                              children: [
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.BtnAtHome.tr(),
                                  style: titleSmallStyle.copyWith(
                                      color: mainColor),
                                ),
                                const Spacer(),
                                Image.asset('assets/images/atHomeIcon.png',
                                    height: 30,
                                    width: 20,
                                    color: greyDarkColor),
                                horizontalSmallSpace,
                              ],
                            ),
                          ),
                          myHorizontalDivider(),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null) {
                                    return '${LocaleKeys.txtFill.tr()} ${LocaleKeys.txtAddress.tr()}';
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
                                  contentPadding: const EdgeInsetsDirectional.only(
                                      start: 20.0,
                                      end: 0.0,
                                      bottom: 0.0,
                                      top: 10.0),
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle:
                                      TextStyle(color: Color(0xFF4F4F4F)),
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
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: HomeReservationOverviewScreen(
                                branchName: locationValue!,
                                testsDataModel: widget.testsDataModel,
                                offersDataModel: widget.offersDataModel,
                                date: widget.date,
                                time: widget.time,
                                familyId: AppCubit.get(context).relationIdList,
                                branchId: extraBranchId!,
                                familyName: memberValue ??
                                    AppCubit.get(context)
                                        .userResourceModel
                                        ?.data
                                        ?.name,
                                addressId: AppCubit.get(context).addressIdList!,
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
        child: Text(item,style: titleSmallStyle,),
      );
}
