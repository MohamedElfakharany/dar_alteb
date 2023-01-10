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

class HomeReservationOverviewScreen extends StatefulWidget {
  HomeReservationOverviewScreen({
    Key? key,
    this.offersDataModel,
    this.testsDataModel,
    required this.date,
    required this.time,
    this.familyId,
    required this.branchId,
    required this.familyName,
    required this.branchName,
    required this.addressId,
  }) : super(key: key);
  final String date;
  final String time;
  final String branchName;
  final String? familyName;
  final int? familyId;
  final int branchId;
  final int addressId;
  TestsDataModel? testsDataModel;
  OffersDataModel? offersDataModel;

  @override
  State<HomeReservationOverviewScreen> createState() =>
      _HomeReservationOverviewScreenState();
}

class _HomeReservationOverviewScreenState
    extends State<HomeReservationOverviewScreen> {
  var couponController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isInvoiceDone = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCheckCouponSuccessState) {
          if (state.successModel.status) {
            showToast(
                msg: state.successModel.message, state: ToastState.success);
            if (widget.testsDataModel != null ||
                widget.offersDataModel != null) {
              if (widget.testsDataModel != null) {
                AppCubit.get(context).getInvoices(
                  testId: widget.testsDataModel?.id,
                  coupon: couponController.text,
                );
              } else {
                AppCubit.get(context).getInvoices(
                  offerId: widget.offersDataModel?.id,
                  coupon: couponController.text,
                );
              }
            } else {
              AppCubit.get(context).getInvoices(
                cartTestId: AppCubit.get(context).cartModel?.extra?.tests,
                cartOfferId: AppCubit.get(context).cartModel?.extra?.offers,
                coupon: couponController.text,
              );
            }
          } else {
            isInvoiceDone = false;
            showToast(state: ToastState.error, msg: state.successModel.message);
          }
        } else if (state is AppCheckCouponErrorState) {
          isInvoiceDone = false;
          showToast(msg: state.error, state: ToastState.error);
        }
        if (state is AppCreateHomeReservationSuccessState) {
          if (state.successModel.status) {
            showToast(
              msg: state.successModel.message,
              state: ToastState.success,
            );
            // Navigator.push(context,FadeRoute(page: ));
            navigateAndFinish(
              context,
              ReservedSuccessScreen(
                date: widget.date,
                time: widget.time,
                isLab: false,
                branchName: widget.branchName,
              ),
            );
          } else {
            showToast(msg: state.successModel.message, state: ToastState.error);
          }
        } else if (state is AppCreateHomeReservationErrorState) {
          showToast(msg: state.error, state: ToastState.error);
        }
        if (state is AppGetInvoicesSuccessState) {
          if (state.invoiceModel.status == true) {
            isInvoiceDone = true;
          } else {
            isInvoiceDone = false;
            showToast(msg: state.invoiceModel.message, state: ToastState.error);
          }
        } else if (state is AppGetInvoicesErrorState) {
          isInvoiceDone = false;
          showToast(msg: state.error, state: ToastState.error);
        }
      },
      builder: (context, state) {
        var cartModel = AppCubit.get(context).cartModel;
        return ScreenUtilInit(
          builder: (ctx, _) => Scaffold(
            backgroundColor: greyExtraLightColor,
            appBar: GeneralAppBar(
              title: LocaleKeys.txtOverview.tr(),
              centerTitle: false,
              appBarColor: greyExtraLightColor,
            ),
            body: Padding(
              padding:
                  const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  widget.testsDataModel?.category?.name ?? '',
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
                      height: 120.0 * (cartModel?.data?.length.toDouble() ?? 0),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => SwipeActionCell(
                          key: const ValueKey(1),
                          trailingActions: [
                            SwipeAction(
                              nestedAction: SwipeNestedAction(
                                /// customize your nested action content
                                content: ConditionalBuilder(
                                  condition:
                                      state is! AppDeleteInquiryLoadingState,
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.red,
                                      ),
                                      width: 180,
                                      height: 60,
                                      child: OverflowBox(
                                        maxWidth: 200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                textAlign: TextAlign.center,
                                                LocaleKeys.BtnDelete.tr(),
                                                style: titleStyle.copyWith(
                                                    color: whiteColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  fallback: (context) => const Center(
                                      child:
                                          CircularProgressIndicator.adaptive()),
                                ),
                              ),

                              /// you should set the default  bg color to transparent
                              color: Colors.transparent,

                              /// set content instead of title of icon
                              content: _getIconButton(Colors.red, Icons.delete),
                              onTap: (handler) async {},
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '# ${cartModel?.data?[index].cartId}',
                                            style: subTitleSmallStyle2,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${cartModel?.data?[index].price} ${LocaleKeys.salary.tr()}',
                                            style: titleSmallStyle2,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                        separatorBuilder: (context, index) => verticalMiniSpace,
                        itemCount: cartModel?.data?.length ?? 0,
                      ),
                    ),
                  verticalMiniSpace,
                  Text(
                    LocaleKeys.txtReservationDetails.tr(),
                    style: titleStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                  verticalMiniSpace,
                  Container(
                    height: 260.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    alignment: AlignmentDirectional.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.txtPatient.tr(),
                                    style: titleStyle.copyWith(
                                        color: greyLightColor),
                                  ),
                                  if (isVisitor == false)
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.txtFieldAddress.tr(),
                                    style: titleStyle.copyWith(
                                        color: greyLightColor),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                'assets/images/reservedSelected.png',
                                width: 25,
                                height: 35,
                                color: mainColor,
                              ),
                              myVerticalDivider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.AppointmentScreenTxtTitle.tr(),
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
                    // height: 110.0,
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
                          Row(
                            children: [
                              Expanded(
                                child: Form(
                                  key: formKey,
                                  child: DefaultFormField(
                                    controller: couponController,
                                    type: TextInputType.text,
                                    validatedText:
                                        LocaleKeys.txtFieldCoupon.tr(),
                                    label: LocaleKeys.txtFieldCoupon.tr(),
                                    onTap: () {},
                                  ),
                                ),
                              ),
                              horizontalMiniSpace,
                              InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
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
                                          BorderRadius.circular(radius)),
                                  child: const Icon(
                                    Icons.send_outlined,
                                    color: whiteColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
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
                        // height: 150.0,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                LocaleKeys.txtSummary.tr(),
                                style: titleSmallStyle.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            myHorizontalDivider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.txtPrice.tr(),
                                        style: titleSmallStyle.copyWith(
                                            color: greyDarkColor,
                                            fontWeight: FontWeight.normal),
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
                                  if (isInvoiceDone)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocaleKeys.txtDiscount.tr(),
                                          style: titleSmallStyle.copyWith(
                                              color: greyDarkColor,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${AppCubit.get(context).invoiceModel?.data?.discount ?? 0}',
                                          textAlign: TextAlign.start,
                                          style: titleSmallStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  if (isInvoiceDone) verticalMicroSpace,
                                  if (isInvoiceDone)
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
                                  if (isInvoiceDone)
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
                                          '${AppCubit.get(context).invoiceModel?.data?.total} ${LocaleKeys.salary.tr()}',
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
                      fallback: (context) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                    ),
                  if (widget.testsDataModel?.id == null &&
                      widget.offersDataModel?.id == null)
                    ConditionalBuilder(
                      condition: state is! AppCheckCouponLoadingState &&
                          state is! AppGetInvoicesLoadingState,
                      builder: (context) => Container(
                        // height: 250.0,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                LocaleKeys.txtSummary.tr(),
                                style: titleSmallStyle.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            myHorizontalDivider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  if (isInvoiceDone)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocaleKeys.txtDiscount.tr(),
                                          style: titleSmallStyle.copyWith(
                                              color: greyDarkColor,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${AppCubit.get(context).invoiceModel?.data?.discount ?? 0}',
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.txtVAT.tr(),
                                        style: titleSmallStyle.copyWith(
                                            color: greyDarkColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const Spacer(),
                                      Text(
                                        cartModel?.extra?.tax,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.txtTotal.tr(),
                                        style: titleSmallStyle.copyWith(
                                            color: greyDarkColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      if (isInvoiceDone == false)
                                        Text(
                                          '${cartModel?.extra?.total} ${LocaleKeys.salary.tr()}',
                                          textAlign: TextAlign.start,
                                          style: titleSmallStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      if (isInvoiceDone == true)
                                        Text(
                                          '${AppCubit.get(context).invoiceModel?.data?.total} ${LocaleKeys.salary.tr()}',
                                          textAlign: TextAlign.start,
                                          style: titleSmallStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                  verticalMicroSpace,
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
                      fallback: (context) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                    ),
                  verticalSmallSpace,
                  ConditionalBuilder(
                    condition: state is! AppCreateHomeReservationLoadingState,
                    builder: (context) => MaterialButton(
                      onPressed: () {
                        if (widget.testsDataModel?.id == null &&
                            widget.offersDataModel?.id == null) {
                          if (cartModel!.extra!.offers!.isNotEmpty &&
                              cartModel.extra!.tests!.isNotEmpty) {
                            AppCubit.get(context).createHomeReservation(
                              date: widget.date,
                              time: widget.time,
                              familyId: widget.familyId,
                              branchId: widget.branchId,
                              coupon: couponController.text,
                              testId: cartModel.extra?.tests,
                              offerId: cartModel.extra?.offers,
                              addressId: widget.addressId,
                            );
                          } else {
                            if (cartModel.extra!.offers!.isEmpty) {
                              AppCubit.get(context).createHomeReservation(
                                date: widget.date,
                                time: widget.time,
                                familyId: widget.familyId,
                                branchId: widget.branchId,
                                coupon: couponController.text,
                                testId: cartModel.extra?.tests,
                                addressId: widget.addressId,
                              );
                            } else if (cartModel.extra!.tests!.isEmpty) {
                              print(widget.date);
                              print(widget.time);
                              print(widget.familyId);
                              print(widget.branchId);
                              print(widget.addressId);
                              print(cartModel.extra?.offers);
                              AppCubit.get(context).createHomeReservation(
                                date: widget.date,
                                time: widget.time,
                                familyId: widget.familyId,
                                branchId: widget.branchId,
                                coupon: couponController.text,
                                offerId: cartModel.extra?.offers,
                                addressId: widget.addressId,
                              );
                            }
                          }
                        } else {
                          if (widget.testsDataModel?.id == null) {
                            AppCubit.get(context).createHomeReservation(
                              date: widget.date,
                              time: widget.time,
                              familyId: widget.familyId,
                              branchId: widget.branchId,
                              coupon: couponController.text,
                              offerId: [widget.offersDataModel?.id],
                              addressId: widget.addressId,
                            );
                          } else if (widget.offersDataModel?.id == null) {
                            AppCubit.get(context).createHomeReservation(
                              date: widget.date,
                              time: widget.time,
                              familyId: widget.familyId,
                              branchId: extraBranchId!,
                              coupon: couponController.text,
                              testId: [widget.testsDataModel?.id],
                              addressId: widget.addressId,
                            );
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
