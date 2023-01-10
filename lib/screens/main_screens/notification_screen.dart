import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    AppCubit.get(context).getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppSeenNotificationsSuccessState) {
          // if (state.successModel.status) {
          //   showToast(
          //       msg: state.successModel.message, state: ToastState.success);
          // } else {
          //   showToast(msg: state.successModel.message, state: ToastState.error);
          // }
          Navigator.pop(context);
        }
        if (state is AppDeleteNotificationsSuccessState) {
          // if (state.successModel.status) {
          //   showToast(
          //       msg: state.successModel.message, state: ToastState.success);
          // } else {
          //   showToast(msg: state.successModel.message, state: ToastState.error);
          // }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.homeTxtNotifications.tr(),
            appBarColor: greyExtraLightColor,
            centerTitle: false,
            leading: ConditionalBuilder(
              condition: state is! AppSeenNotificationsLoadingState,
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: greyDarkColor,
                ),
                onPressed: () {
                  AppCubit.get(context).notificationSeen().then((value) {
                    if (state is AppDeleteNotificationsSuccessState) {
                      if (state.successModel.status == true) {
                        if (kDebugMode) {
                          print('inside true');
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        if (kDebugMode) {
                          print('inside false');
                        }
                        // Navigator.pop(context);
                        showToast(
                            msg: state.successModel.message,
                            state: ToastState.error);
                      }
                    } else if (state is AppDeleteNotificationsErrorState) {
                      if (kDebugMode) {
                        print('inside error');
                      }
                      Navigator.pop(context);
                    }
                    if (state is AppSeenNotificationsSuccessState) {
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            actions: [
              InkWell(
                onTap: () {
                  if (AppCubit.get(context).notificationsModel?.data?.isEmpty ==
                      true) {
                    showToast(
                      msg: LocaleKeys.txtNoNotifications.tr(),
                      state: ToastState.error,
                    );
                  } else {
                    showPopUp(
                      context,
                      Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Column(
                          children: [
                            verticalSmallSpace,
                            Text(
                              LocaleKeys.txtDeleteNotifications.tr(),
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            verticalMediumSpace,
                            GeneralButton(
                              title: LocaleKeys.BtnDelete.tr(),
                              height: 35,
                              width: double.infinity,
                              btnBackgroundColor: redColor,
                              txtColor: whiteColor,
                              onPress: () {
                                AppCubit.get(context)
                                    .deleteNotifications()
                                    .then((value) {
                                  Navigator.pop(context);
                                }).catchError((error) {});
                              },
                            ),
                            verticalSmallSpace,
                            GeneralUnfilledButton(
                              title: LocaleKeys.BtnCancel.tr(),
                              height: 35,
                              width: double.infinity,
                              btnRadius: 8,
                              color: greyDarkColor,
                              borderColor: greyDarkColor,
                              onPress: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: DefaultTextButton(
                  title:
                      '${LocaleKeys.BtnDelete.tr()} ${LocaleKeys.txtAll.tr()}',
                ),
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition:
                AppCubit.get(context).notificationsModel?.data?.isEmpty ==
                    false,
            builder: (context) => ConditionalBuilder(
              condition: state is! AppGetNotificationsLoadingState &&
                  state is! AppDeleteNotificationsLoadingState,
              builder: (context) => Padding(
                padding: const EdgeInsets.only(
                    right: 20.0, bottom: 20.0, left: 20.0),
                child: ListView.separated(
                  itemBuilder: (context, index) => NotificationsCard(
                    notificationsDataModel:
                        AppCubit.get(context).notificationsModel!.data![index],
                  ),
                  separatorBuilder: (context, index) => verticalSmallSpace,
                  itemCount:
                      AppCubit.get(context).notificationsModel?.data?.length ??
                          0,
                ),
              ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
            fallback: (context) =>
                ScreenHolder(msg: LocaleKeys.homeTxtNotifications.tr()),
          ),
        );
      },
    );
  }
}
