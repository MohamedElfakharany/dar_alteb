import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dar_elteb/screens/main_screens/reservations/details_screens/rate_screens/thank_rating_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ExperienceRateScreen extends StatefulWidget {
  const ExperienceRateScreen(
      {Key? key, required this.reservationId, required this.fromHome})
      : super(key: key);
  final int reservationId;
  final bool fromHome;

  @override
  State<ExperienceRateScreen> createState() => _ExperienceRateScreenState();
}

class _ExperienceRateScreenState extends State<ExperienceRateScreen> {
  final messageController = TextEditingController();
  int rate = 3;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppRateTechnicalSuccessState) {
          if (state.successModel.status == true) {
            showCustomBottomSheet(context,
                bottomSheetContent: const ThankRatingScreen(),
                bottomSheetHeight: 0.6);
          } else {
            showToast(state: ToastState.error, msg: state.successModel.message);
          }
        }
      },
      builder: (context, state) {
        return Center(
          child: Form(
            key: formKey,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  radius,
                ),
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
                                initialRating: rate.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) =>
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  rate = rating.toInt();
                                  if (kDebugMode) {
                                    print(rating);
                                  }
                                },
                              ),
                              verticalMediumSpace,
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      0.15, //when it reach the max it will use scroll
                                  // maxWidth: width,
                                ),
                                child: DefaultFormField(
                                  controller: messageController,
                                  expend: true,
                                  type: TextInputType.multiline,
                                  label: LocaleKeys.txtSayYourExperience.tr(),
                                  hintText:
                                  LocaleKeys.txtSayYourExperience.tr(),
                                  height: 100.0,
                                  onTap: () {},
                                  contentPadding:
                                  const EdgeInsetsDirectional.only(
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
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: ConditionalBuilder(
                                        condition: state is! AppRateTechnicalLoadingState,
                                        builder: (context) =>
                                            InkWell(
                                              onTap: () {
                                                if (widget.fromHome == true) {
                                                  AppCubit.get(context)
                                                      .rateTechnical(
                                                    fromHome: true,
                                                    rate: rate,
                                                    reservationId: widget
                                                        .reservationId,
                                                    message: messageController
                                                        .text,
                                                  );
                                                }else {
                                                  AppCubit.get(context).rateTechnical(
                                                    fromHome: false,
                                                    rate: rate,
                                                    reservationId: widget.reservationId,
                                                    message: messageController.text,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: mainColor,
                                                  borderRadius:
                                                  BorderRadius.circular(radius),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                      LocaleKeys.BtnSubmit.tr(),
                                                      style: titleStyle
                                                          .copyWith(
                                                          fontSize: 20.0,
                                                          color: whiteColor,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )),
                                              ),
                                            ),
                                        fallback: (context) =>
                                        const Center(
                                            child: CircularProgressIndicator
                                                .adaptive()),
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
                                        borderRadius:
                                        BorderRadius.circular(radius),
                                      ),
                                      child: Center(
                                        child: Text(
                                          LocaleKeys.BtnLater.tr(),
                                          style: subTitleSmallStyle,
                                        ),
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
      },
    );
  }
}
