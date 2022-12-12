// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/test_models/offers_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/tests_model.dart';
import 'package:dar_elteb/screens/main_screens/reservations/reserved_success_screen.dart';
import 'package:dar_elteb/shared/components/cached_network_image.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LabReservationOverviewScreen extends StatefulWidget {
  LabReservationOverviewScreen(
      {Key? key,
      this.offersDataModel,
      this.testsDataModel,
      required this.date,
      required this.time,
      this.familyId,
      required this.branchId,
      required this.familyName,
      required this.branchName})
      : super(key: key);
  final String date;
  final String time;
  final String branchName;
  final String? familyName;
  final int? familyId;
  final int branchId;
  TestsDataModel? testsDataModel;
  OffersDataModel? offersDataModel;

  @override
  State<LabReservationOverviewScreen> createState() =>
      _LabReservationOverviewScreenState();
}

class _LabReservationOverviewScreenState
    extends State<LabReservationOverviewScreen> {
  var couponController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final _focusNodes =
      Iterable<int>.generate(1).map((_) => FocusNode()).toList();

  @override
  void initState() {
    if (widget.testsDataModel == null && widget.offersDataModel == null) {
      // AppCubit.get(context).getCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCheckCouponSuccessState) {
          if (state.successModel.status) {
            AppCubit.get(context).getInvoices(testId: [
              widget.testsDataModel?.id ?? widget.offersDataModel?.id
            ]);
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(state.successModel.message),
              ),
            );
          }
        } else if (state is AppCheckCouponErrorState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                state.error.toString(),
              ),
            ),
          );
        }
        if (state is AppCreateLabReservationSuccessState) {
          if (state.successModel.status) {
            showToast(
              msg: state.successModel.message,
              state: ToastState.success,
            );
            navigateAndFinish(
              context,
              ReservedSuccessScreen(
                  date: widget.date,
                  time: widget.time,
                  isLab: true,
                  branchName: widget.branchName),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(state.successModel.message),
              ),
            );
          }
        } else if (state is AppCreateLabReservationErrorState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                state.error.toString(),
              ),
            ),
          );
        }
        if (state is AppGetInvoicesSuccessState) {
          if (state.successModel.status) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(state.successModel.message),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(state.successModel.message),
              ),
            );
          }
        } else if (state is AppGetInvoicesErrorState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                state.error.toString(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        var cartModel = AppCubit.get(context).cartModel;
        print('widget.branchName : ${widget.branchName}');
        return ScreenUtilInit(
          builder: (ctx, _) => Scaffold(
            backgroundColor: greyExtraLightColor,
            appBar: GeneralAppBar(
              title: LocaleKeys.txtOverview.tr(),
              centerTitle: false,
              appBarColor: greyExtraLightColor,
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetCartLoadingState,
              builder: (context) => Padding(
                padding: const EdgeInsets.only(
                    right: 20.0, left: 20.0, bottom: 20.0),
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
                        if (widget.testsDataModel != null ||
                            widget.offersDataModel != null)
                          Container(
                            height: 110.0,
                            width: 110.0,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(radius),
                              border: Border.all(
                                width: 1,
                                color: greyLightColor,
                              ),
                            ),
                            alignment: AlignmentDirectional.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 4),
                            child: Row(
                              children: [
                                horizontalMicroSpace,
                                CachedNetworkImageNormal(
                                  imageUrl: widget.offersDataModel?.image ??
                                      widget.testsDataModel?.image ??
                                      '',
                                  width: 80,
                                  height: 80,
                                ),
                                horizontalSmallSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.offersDataModel?.title ??
                                            widget.testsDataModel?.title ??
                                            '',
                                        style: titleSmallStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        widget.testsDataModel?.category?.name ??
                                            '',
                                        style: subTitleSmallStyle2,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${widget.offersDataModel?.discount ?? widget.testsDataModel?.price} ${LocaleKeys.salary.tr()}',
                                        style: titleSmallStyle2,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.testsDataModel == null &&
                            widget.offersDataModel == null)
                          SizedBox(
                            height: 120.0 * (cartModel?.data?.length ?? 0),
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => SwipeActionCell(
                                key: const ValueKey(1),
                                trailingActions: [
                                  SwipeAction(
                                    nestedAction: SwipeNestedAction(
                                      /// customize your nested action content
                                      content: ConditionalBuilder(
                                        condition: state
                                            is! AppDeleteInquiryLoadingState,
                                        builder: (context) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        fallback: (context) => const Center(
                                            child: CircularProgressIndicator
                                                .adaptive()),
                                      ),
                                    ),

                                    /// you should set the default  bg color to transparent
                                    color: Colors.transparent,

                                    /// set content instead of title of icon
                                    content: _getIconButton(
                                        Colors.red, Icons.delete),
                                    onTap: (handler) async {
                                      AppCubit.get(context).deleteCart(
                                        cartId: AppCubit.get(context)
                                            .cartModel!
                                            .data![index]
                                            .id,
                                      );
                                    },
                                  ),
                                ],
                                child: Container(
                                  height: 110.0,
                                  width: 110.0,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(radius),
                                    border: Border.all(
                                      width: 1,
                                      color: greyLightColor,
                                    ),
                                  ),
                                  alignment: AlignmentDirectional.center,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  child: Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Row(
                                        children: [
                                          horizontalMicroSpace,
                                          CachedNetworkImageNormal(
                                            imageUrl:
                                                '${cartModel?.data?[index].image}',
                                            width: 80,
                                            height: 80,
                                          ),
                                          horizontalSmallSpace,
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${cartModel?.data?[index].title}',
                                                  style: titleSmallStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  '# ${cartModel?.data?[index].cartId}',
                                                  style: subTitleSmallStyle2,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  '${cartModel?.data?[index].price} ${LocaleKeys.salary.tr()}',
                                                  style: titleSmallStyle2,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  verticalMiniSpace,
                              itemCount: cartModel?.data?.length ?? 0,
                            ),
                          ),
                        verticalMiniSpace,
                        Text(
                          LocaleKeys.txtReservationDetails.tr(),
                          style:
                              titleStyle.copyWith(fontWeight: FontWeight.w500),
                        ),
                        verticalMiniSpace,
                        Container(
                          height: 250.0,
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
                                    Image.asset(
                                      'assets/images/profile.png',
                                      width: 25,
                                      height: 35,
                                      color: mainColor,
                                    ),
                                    myVerticalDivider(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          LocaleKeys.txtPatient.tr(),
                                          style: titleStyle.copyWith(
                                              color: greyLightColor),
                                        ),
                                        if (AppCubit.get(context).isVisitor ==
                                            false)
                                          Text(
                                            widget.familyName ??
                                                AppCubit.get(context)
                                                    .userResourceModel
                                                    ?.data
                                                    ?.name,
                                            textAlign: TextAlign.start,
                                            style: titleSmallStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              myHorizontalDivider(),
                              Expanded(
                                child: Row(
                                  children: [
                                    horizontalSmallSpace,
                                    Image.asset(
                                      'assets/images/location.jpg',
                                      width: 25,
                                      height: 35,
                                    ),
                                    myVerticalDivider(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          LocaleKeys.txtReservationDetails.tr(),
                                          style: titleStyle.copyWith(
                                              color: greyLightColor),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            widget.branchName,
                                            textAlign: TextAlign.start,
                                            style: titleSmallStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              myHorizontalDivider(),
                              Expanded(
                                child: Row(
                                  children: [
                                    horizontalSmallSpace,
                                    Image.asset(
                                      'assets/images/reserved.png',
                                      width: 25,
                                      height: 35,
                                      color: mainColor,
                                    ),
                                    myVerticalDivider(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          LocaleKeys.AppointmentScreenTxtTitle
                                              .tr(),
                                          style: titleStyle.copyWith(
                                              color: greyLightColor),
                                        ),
                                        Text(
                                          '${widget.date} - ${widget.time}',
                                          textAlign: TextAlign.start,
                                          style: titleSmallStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalMiniSpace,
                        Container(
                          height: 120.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.txtHaveCoupon.tr(),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DefaultFormField(
                                          controller: couponController,
                                          type: TextInputType.text,
                                          label: LocaleKeys.txtFieldCoupon.tr(),
                                          validatedText:
                                              LocaleKeys.txtFieldCoupon.tr(),
                                          onTap: () {},
                                        ),
                                      ),
                                      horizontalMiniSpace,
                                      InkWell(
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            AppCubit.get(context).checkCoupon(
                                                coupon: couponController.text);
                                          }
                                        },
                                        child: Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                              color: darkColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radius)),
                                          child: const Icon(
                                            Icons.send_outlined,
                                            color: whiteColor,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        verticalMiniSpace,
                        if (widget.testsDataModel?.id != null ||
                            widget.offersDataModel?.id != null)
                          ConditionalBuilder(
                            condition: state is! AppCheckCouponLoadingState &&
                                state is! AppGetInvoicesLoadingState,
                            builder: (context) => Container(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalSmallSpace,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      LocaleKeys.txtSummary.tr(),
                                      style: titleSmallStyle.copyWith(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  myHorizontalDivider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              LocaleKeys.txtPrice.tr(),
                                              style: titleSmallStyle.copyWith(
                                                  color: greyDarkColor,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${widget.offersDataModel?.discount ?? widget.testsDataModel?.price} ${LocaleKeys.salary.tr()}',
                                              textAlign: TextAlign.start,
                                              style: titleSmallStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        verticalMicroSpace,
                                        const MySeparator(),
                                        verticalMicroSpace,
                                        verticalMicroSpace,
                                        Row(
                                          children: [
                                            Text(
                                              LocaleKeys.txtAddedTax.tr(),
                                              textAlign: TextAlign.start,
                                              style: titleSmallStyle.copyWith(
                                                  color: greyDarkColor,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator.adaptive()),
                          ),
                        if (widget.testsDataModel?.id == null &&
                            widget.offersDataModel?.id == null)
                          Container(
                            height: 250.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            alignment: AlignmentDirectional.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                verticalSmallSpace,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    LocaleKeys.txtSummary.tr(),
                                    style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                myHorizontalDivider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            LocaleKeys.txtItems.tr(),
                                            style: titleSmallStyle.copyWith(
                                                color: greyDarkColor,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${cartModel?.data?.length ?? 1}',
                                            textAlign: TextAlign.start,
                                            style: titleSmallStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      verticalMicroSpace,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            LocaleKeys.txtPrice.tr(),
                                            style: titleSmallStyle.copyWith(
                                                color: greyDarkColor,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${cartModel?.extra?.price} ${LocaleKeys.salary.tr()}',
                                            textAlign: TextAlign.start,
                                            style: titleSmallStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      verticalMicroSpace,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            LocaleKeys.txtVAT.tr(),
                                            style: titleSmallStyle.copyWith(
                                                color: greyDarkColor,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${cartModel?.extra?.tax}',
                                            textAlign: TextAlign.start,
                                            style: titleSmallStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      verticalMicroSpace,
                                      const MySeparator(),
                                      verticalMicroSpace,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            LocaleKeys.txtTotal.tr(),
                                            style: titleSmallStyle.copyWith(
                                                color: greyDarkColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${cartModel?.extra?.total} ${LocaleKeys.salary.tr()}',
                                            textAlign: TextAlign.start,
                                            style: titleSmallStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            LocaleKeys.txtAddedTax.tr(),
                                            textAlign: TextAlign.start,
                                            style: titleSmallStyle.copyWith(
                                                color: greyDarkColor,
                                                fontWeight: FontWeight.normal),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        verticalSmallSpace,
                        ConditionalBuilder(
                          condition:
                              state is! AppCreateLabReservationLoadingState,
                          builder: (context) => MaterialButton(
                            onPressed: () {
                              if (widget.testsDataModel?.id == null &&
                                  widget.offersDataModel?.id == null) {
                                if (cartModel!.extra!.offers!.isNotEmpty &&
                                    cartModel.extra!.tests!.isNotEmpty) {
                                  AppCubit.get(context).createLabReservation(
                                    date: widget.date,
                                    time: widget.time,
                                    familyId: widget.familyId,
                                    branchId: widget.branchId,
                                    coupon: couponController.text,
                                    offerId: cartModel.extra!.offers,
                                    testId: cartModel.extra!.tests,
                                  );
                                }
                                else {
                                  if (cartModel.extra!.offers!.isEmpty) {
                                    AppCubit.get(context).createLabReservation(
                                      date: widget.date,
                                      time: widget.time,
                                      familyId: widget.familyId,
                                      branchId: widget.branchId,
                                      coupon: couponController.text,
                                      testId: cartModel.extra?.tests,
                                    );
                                  }
                                  else if (cartModel.extra!.tests!.isEmpty) {
                                    AppCubit.get(context).createLabReservation(
                                        date: widget.date,
                                        time: widget.time,
                                        familyId: widget.familyId,
                                        branchId: widget.branchId,
                                        coupon: couponController.text,
                                        offerId: cartModel.extra?.offers);
                                  }
                                }
                              } else {
                                if (widget.testsDataModel?.id == null) {
                                  AppCubit.get(context).createLabReservation(
                                    date: widget.date,
                                    time: widget.time,
                                    familyId: widget.familyId,
                                    branchId: widget.branchId,
                                    coupon: couponController.text,
                                    offerId: ["${widget.offersDataModel?.id}"],
                                  );
                                } else if (widget.offersDataModel?.id == null) {
                                  AppCubit.get(context).createLabReservation(
                                      date: widget.date,
                                      time: widget.time,
                                      familyId: widget.familyId,
                                      branchId: widget.branchId,
                                      coupon: couponController.text,
                                      testId: ['${widget.testsDataModel?.id}']);
                                }
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
                                  LocaleKeys.BtnConfirm.tr(),
                                  style: titleStyle.copyWith(
                                    fontSize: 20.0,
                                    color: whiteColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          fallback: (context) => const Center(
                              child: CircularProgressIndicator.adaptive()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
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
