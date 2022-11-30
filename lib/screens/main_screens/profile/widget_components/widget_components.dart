// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/profile_models/address_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/families_model.dart';
import 'package:dar_elteb/models/patient_models/profile_models/medical-inquiries.dart';
import 'package:dar_elteb/screens/main_screens/profile/family/edit_member.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class FamiliesMemberCard extends StatelessWidget {
  FamiliesMemberCard({Key? key, required this.familiesDataModel})
      : super(key: key);
  FamiliesDataModel familiesDataModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 147,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(width: 1, color: greyDarkColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: CachedNetworkImage(
                      imageUrl: familiesDataModel.profile,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const SizedBox(
                        width: 30,
                        height: 30,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: mainColor,
                        )),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: whiteColor),
                        child: const Icon(
                          Icons.perm_identity,
                          size: 100,
                          color: mainColor,
                        ),
                      ),
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Text(
                    familiesDataModel.name,
                    style: titleStyle.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.monitor_heart_outlined,
                        color: mainColor,
                      ),
                      horizontalMicroSpace,
                      Text(
                        familiesDataModel.relation!.title,
                        // '',
                        style:
                            subTitleSmallStyle.copyWith(color: mainLightColor),
                      ),
                    ],
                  ),
                  Text(
                    familiesDataModel.gender,
                    style: subTitleSmallStyle,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      FadeRoute(
                        page: EditMemberScreen(
                            familiesDataModel: familiesDataModel),
                      ),
                    );
                  },
                  child: Container(
                    height: 35,
                    width: 90,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit,
                          color: whiteColor,
                        ),
                        horizontalMicroSpace,
                        Text(
                          LocaleKeys.txtEdit.tr(),
                          style:
                              subTitleSmallStyle2.copyWith(color: whiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MedicalInquiriesCard extends StatelessWidget {
  const MedicalInquiriesCard(
      {Key? key, required this.medicalInquiriesDataModel})
      : super(key: key);

  final MedicalInquiriesDataModel medicalInquiriesDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(
              radius,
            ),
            border: Border.all(
              width: 1,
              color: greyLightColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: mainLightColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      radius,
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    size: 35.0,
                    color: mainColor,
                  ),
                ),
                horizontalSmallSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        medicalInquiriesDataModel.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${medicalInquiriesDataModel.date?.time ?? ''} ${medicalInquiriesDataModel.date?.date ?? ''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: subTitleSmallStyle,
                      ),
                    ],
                  ),
                ),
                horizontalSmallSpace,
                if (medicalInquiriesDataModel.answer?.user == null)
                  Container(
                    width: 60.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: greenColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        radius,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'New',
                        style: titleSmallStyleGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard(
      {Key? key, required this.addressDataModel, required this.index})
      : super(key: key);
  final index;
  final AddressDataModel addressDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Widget isSelectedAddress;
        if (AppCubit.get(context).addressModel?.data?[index].isSelected ==
            '1') {
          isSelectedAddress = SvgPicture.asset(
            'assets/images/checkTrue.svg',
            width: 20,
            height: 20,
          );
        } else {
          isSelectedAddress = const Icon(
            Icons.adjust_rounded,
            size: 20,
            color: greyDarkColor,
          );
        }
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(width: 1, color: greyDarkColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isSelectedAddress,
                horizontalSmallSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${addressDataModel.address}',
                        style: titleSmallStyle.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (addressDataModel.specialMark != '')
                      Text(
                        '${addressDataModel.specialMark}',
                        style: titleSmallStyle.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.location_on_rounded,
                  color: greyDarkColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}