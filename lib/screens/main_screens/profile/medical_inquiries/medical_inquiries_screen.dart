import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/profile/medical_inquiries/inquiry_screen.dart';
import 'package:dar_elteb/screens/main_screens/profile/medical_inquiries/new_inquiry.dart';
import 'package:dar_elteb/screens/main_screens/profile/widget_components/widget_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class MedicalInquiriesScreen extends StatefulWidget {
  const MedicalInquiriesScreen({Key? key}) : super(key: key);

  @override
  State<MedicalInquiriesScreen> createState() => _MedicalInquiriesScreenState();
}

class _MedicalInquiriesScreenState extends State<MedicalInquiriesScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 0),
      () async {
        AppCubit.get(context).getMedicalInquiries();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtMedicalInquiries.tr(),
            appBarColor: greyExtraLightColor,
            centerTitle: false,
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(right: 20.0, bottom: 20.0, left: 20.0),
            child: Column(
              children: [
                GeneralButton(
                  title: LocaleKeys.txtNewInquiries.tr(),
                  onPress: () {
                    Navigator.push(
                        context, FadeRoute(page: const NewInquiryScreen()));
                  },
                ),
                verticalMediumSpace,
                ConditionalBuilder(
                  condition: state is! AppGetMedicalInquiriesLoadingState && state is! AppCreateInquiryLoadingState,
                  builder: (context) => ConditionalBuilder(
                    condition:
                        AppCubit.get(context).medicalInquiriesModel?.data !=
                            null,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => SwipeActionCell(
                          key: ValueKey(AppCubit.get(context)
                              .medicalInquiriesModel!
                              .data![index]),
                          trailingActions: [
                            SwipeAction(
                              nestedAction: SwipeNestedAction(
                                /// customize your nested action content
                                content: ConditionalBuilder(
                                  condition:
                                      state is! AppDeleteInquiryLoadingState,
                                  builder: (context) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.red,
                                    ),
                                    width: 130,
                                    height: 60,
                                    child: OverflowBox(
                                      maxWidth: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          Text(LocaleKeys.BtnDelete.tr(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  fallback: (context) => const Center(
                                      child: CircularProgressIndicator.adaptive()),
                                ),
                              ),
                              /// you should set the default  bg color to transparent
                              color: Colors.transparent,
                              /// set content instead of title of icon
                              content: _getIconButton(Colors.red, Icons.delete),
                              onTap: (handler) async {
                                AppCubit.get(context).deleteInquiry(
                                  inquiryId: AppCubit.get(context)
                                      .medicalInquiriesModel!
                                      .data![index]
                                      .id,
                                );
                              },
                            ),
                          ],
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: InquiryScreen(
                                    medicalInquiriesDataModel:
                                        AppCubit.get(context)
                                            .medicalInquiriesModel!
                                            .data![index],
                                  ),
                                ),
                              );
                            },
                            child: MedicalInquiriesCard(
                              medicalInquiriesDataModel: AppCubit.get(context)
                                  .medicalInquiriesModel!
                                  .data![index],
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            verticalSmallSpace,
                        itemCount: AppCubit.get(context)
                                .medicalInquiriesModel
                                ?.data
                                ?.length ??
                            0,
                      ),
                    ),
                    fallback: (context) =>
                        ScreenHolder(msg: LocaleKeys.txtMedicalInquiries.tr()),
                  ),
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        /// set you real bg color in your content
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
