// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/reservations/details_screens/home_appointments/home_appointments_screen.dart';
import 'package:dar_elteb/screens/main_screens/reservations/details_screens/lab_appointments/lab_appointments_screen.dart';
import 'package:dar_elteb/shared/components/cached_network_image.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class CartScreen extends StatelessWidget {
   CartScreen({Key? key}) : super(key: key);

  var couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cartModel = AppCubit.get(context).cartModel;
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtReservationDetails.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
            child: ConditionalBuilder(
              condition: state is! AppGetCartLoadingState ||
                  state is! AppDeleteCartLoadingState,
              builder: (context) {
                return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 120.0 * (cartModel?.data?.length.toDouble() ?? 0),
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
                                    child:
                                        CircularProgressIndicator.adaptive()),
                              ),
                            ),

                            /// you should set the default  bg color to transparent
                            color: Colors.transparent,

                            /// set content instead of title of icon
                            content: _getIconButton(Colors.red, Icons.delete),
                            onTap: (handler) async {
                              AppCubit.get(context).deleteCart(
                                cartId: AppCubit.get(context)
                                    .cartModel!
                                    .data![index]
                                    .cartId,
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
                  Container(
                    height: 110.0,
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
                                    type: TextInputType.number,
                                    label: LocaleKeys.txtFieldCoupon.tr(),
                                  ),
                                ),
                                horizontalMiniSpace,
                                Container(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSmallSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            LocaleKeys.txtSummary.tr(),
                            style: titleSmallStyle.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        myHorizontalDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                  MaterialButton(
                    onPressed: () {
                      showCustomBottomSheet(
                        context,
                        bottomSheetContent: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(radius),
                              topRight: Radius.circular(radius),
                            ),
                          ),
                          padding: const EdgeInsetsDirectional.only(
                              start: 20.0, end: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.TxtPopUpReservationType.tr(),
                                style: titleStyle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                LocaleKeys.TxtPopUpReservationTypeSecond.tr(),
                                style: subTitleSmallStyle.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                              verticalSmallSpace,
                              InkWell(
                                onTap: () {
                                  if (kDebugMode) {
                                    print('lab');
                                  }
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: LabAppointmentsScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(radius),
                                    border:
                                        Border.all(width: 1, color: mainColor),
                                    color: greyExtraLightColor,
                                  ),
                                  child: Row(
                                    children: [
                                      horizontalSmallSpace,
                                      Text(
                                        LocaleKeys.BtnAtLab.tr(),
                                        style: titleStyle.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: mainColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const Spacer(),
                                      Image.asset('assets/images/atLabIcon.png',
                                          height: 40,
                                          width: 30,
                                          color: mainColor),
                                      horizontalSmallSpace,
                                    ],
                                  ),
                                ),
                              ),
                              verticalSmallSpace,
                              InkWell(
                                onTap: () {
                                  if (kDebugMode) {
                                    print('home');
                                  }
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: HomeAppointmentsScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(radius),
                                    color: greyExtraLightColor,
                                    border:
                                        Border.all(width: 1, color: mainColor),
                                  ),
                                  child: Row(
                                    children: [
                                      horizontalSmallSpace,
                                      Text(
                                        LocaleKeys.BtnAtHome.tr(),
                                        style: titleStyle.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: mainColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.home_outlined,
                                        color: mainColor,
                                        size: 40,
                                      ),
                                      horizontalSmallSpace,
                                    ],
                                  ),
                                ),
                              ),
                              verticalSmallSpace,
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: greyLightColor,
                                    borderRadius: BorderRadius.circular(radius),
                                  ),
                                  child: Center(
                                      child: Text(
                                    LocaleKeys.BtnCancel.tr(),
                                    style: titleStyle.copyWith(
                                        fontSize: 25.0,
                                        color: whiteColor,
                                        fontWeight: FontWeight.normal),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        bottomSheetHeight: 0.5,
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      child: Center(
                          child: Text(
                        LocaleKeys.TxtReservationScreenTitle.tr(),
                        style: titleStyle.copyWith(
                            fontSize: 20.0,
                            color: whiteColor,
                            fontWeight: FontWeight.normal),
                      )),
                    ),
                  ),
                  verticalSmallSpace,
                ],
              );
              },
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
