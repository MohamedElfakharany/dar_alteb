import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dar_elteb/screens/main_screens/reservations/details_screens/rate_screens/thank_rating_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ExperienceRateScreen extends StatefulWidget {
  const ExperienceRateScreen({Key? key}) : super(key: key);

  @override
  State<ExperienceRateScreen> createState() => _ExperienceRateScreenState();
}

class _ExperienceRateScreenState extends State<ExperienceRateScreen> {

  final messageController = TextEditingController();
  double rate = 4;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius,),
          ),
          child: Column(
            children: [
              verticalMicroSpace,
              // Align(
              //     alignment: AlignmentDirectional.centerStart,
              //     child: IconButton(onPressed: (){
              //       Navigator.pop(context);
              //     }, icon: const Icon(Icons.close,color: greyDarkColor,size: 30,),)),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10),
                      child: Column(
                        children: [
                          verticalMediumSpace,
                          Text(
                            LocaleKeys.txtWeAreHappy.tr(),
                            style: titleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          verticalMediumSpace,
                          Text(
                            LocaleKeys.txtRateYourCurrentExperience.tr(),
                            style: subTitleSmallStyle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          verticalMediumSpace,
                          RatingBar.builder(
                            initialRating: rate,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              rate = rating;
                              if (kDebugMode) {
                                print(rating);
                              }
                            },
                          ),
                          verticalMediumSpace,
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height *
                                  0.15, //when it reach the max it will use scroll
                              // maxWidth: width,
                            ),
                            child: DefaultFormField(
                              controller: messageController,
                              expend: true,
                              type: TextInputType.multiline,
                              label: LocaleKeys.txtSayYourExperience.tr(),
                              hintText: LocaleKeys.txtSayYourExperience.tr(),
                              height: 100.0,
                              contentPadding: const EdgeInsetsDirectional.only(
                                top: 10.0,
                                start: 20.0,
                                bottom: 10.0,
                              ),
                            ),
                          ),
                          verticalMediumSpace,
                          Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {
                                    showCustomBottomSheet(context,
                                        bottomSheetContent: const ThankRatingScreen(),
                                        bottomSheetHeight: 0.6);
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(radius),
                                    ),
                                    child: Center(
                                        child: Text(
                                          LocaleKeys.BtnSubmit.tr(),
                                          style: titleStyle.copyWith(
                                              fontSize: 20.0,
                                              color: whiteColor,
                                              fontWeight: FontWeight.normal),
                                        )),
                                  ),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: greyExtraLightColor,
                                    borderRadius: BorderRadius.circular(radius),
                                  ),
                                  child: Center(
                                    child: Text(LocaleKeys.BtnLater.tr(),style: subTitleSmallStyle,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSmallSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
