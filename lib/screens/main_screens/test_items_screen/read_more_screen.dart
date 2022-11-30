// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:dar_elteb/models/patient_models/test_models/offers_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/tests_model.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ReadMoreScreen extends StatelessWidget {
  ReadMoreScreen({Key? key, this.testsDataModel, this.offersDataModel})
      : super(key: key);
  TestsDataModel? testsDataModel;
  OffersDataModel? offersDataModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralAppBar(
        title: LocaleKeys.txtAnalysisPreparations.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                CachedNetworkImage(
                  imageUrl: testsDataModel?.image ?? offersDataModel?.image,
                  fit: BoxFit.cover,
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      if (offersDataModel?.discount != null)
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: redColor,
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        child: const Center(
                          child: Text(
                            '%',
                            style: TextStyle(color: whiteColor,fontSize: 20),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (offersDataModel?.gender == 'Male' || testsDataModel?.gender == 'Male')
                        Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                            color: mainLightColor,
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  offersDataModel?.gender ?? testsDataModel?.gender,
                                  style: const TextStyle(color: whiteColor),
                                ),
                                horizontalMicroSpace,
                                const Icon(
                                  Icons.male,
                                  color: whiteColor,
                                )
                              ],
                            ),
                          ),
                        )
                      else if (offersDataModel?.gender == 'Female' || testsDataModel?.gender == 'Male')
                        Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                            color: pinkColor,
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  offersDataModel?.gender,
                                  style: const TextStyle(color: whiteColor),
                                ),
                                const Icon(
                                  Icons.female,
                                  color: whiteColor,
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                testsDataModel?.title ?? offersDataModel?.title,
                style: titleStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            HtmlWidget(testsDataModel?.preparation ?? offersDataModel?.preparation,),
          ],
        ),
      ),
    );
  }
}
