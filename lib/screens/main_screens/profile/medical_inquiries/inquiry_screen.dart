import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/profile_models/medical-inquiries.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class InquiryScreen extends StatelessWidget {
  const InquiryScreen({Key? key, required this.medicalInquiriesDataModel})
      : super(key: key);
  final MedicalInquiriesDataModel medicalInquiriesDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtMedicalInquiries.tr(),
            appBarColor: whiteColor,
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child: Scrollbar(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: greyExtraLightColor,
                      ),
                      child: Center(
                        child: Text(
                          medicalInquiriesDataModel.date?.date ?? '',
                          style: subTitleSmallStyle,
                        ),
                      ),
                    ),
                  ),
                  verticalSmallSpace,
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            color: mainLightColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              medicalInquiriesDataModel.message ?? '',
                              style: subTitleSmallStyle.copyWith(
                                  color: whiteColor),
                            ),
                          ),
                        ),
                        verticalSmallSpace,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: CachedNetworkImage(
                            imageUrl: medicalInquiriesDataModel.file,
                          ),
                        ),
                        verticalMicroSpace,
                        Text(
                          medicalInquiriesDataModel.date?.time ?? '',
                          textAlign: TextAlign.start,
                          style: subTitleSmallStyle3,
                        ),
                      ],
                    ),
                  ),
                  verticalSmallSpace,
                  if (medicalInquiriesDataModel.answer?.date?.date != null)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: greyExtraLightColor,
                      ),
                      child: Center(
                        child: Text(
                          medicalInquiriesDataModel.answer?.date?.date ?? '',
                          style: subTitleSmallStyle,
                        ),
                      ),
                    ),
                  ),
                  verticalSmallSpace,
                  if (medicalInquiriesDataModel.answer?.date?.date != null)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            color: greyLightColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${medicalInquiriesDataModel.answer?.message ?? ''} \n \n ${medicalInquiriesDataModel.answer?.user?.name ?? ''},',
                              textAlign: TextAlign.start,
                              style: subTitleSmallStyle.copyWith(
                                  color: whiteColor),
                            ),
                          ),
                        ),
                        verticalSmallSpace,
                        medicalInquiriesDataModel.answer == null
                            ? Container()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      medicalInquiriesDataModel.answer?.file ??
                                          '',
                                ),
                              ),
                        verticalMicroSpace,
                        Text(
                          medicalInquiriesDataModel.answer?.date?.time ?? '',
                          style: subTitleSmallStyle3,
                        ),
                      ],
                    ),
                  ),
                  if (medicalInquiriesDataModel.answer?.date?.date == null)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: greyExtraLightColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ScreenHolder(msg: LocaleKeys.txtAnswer.tr()),
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
