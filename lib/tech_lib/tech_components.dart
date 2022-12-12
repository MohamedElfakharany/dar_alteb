// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/screens/main_screens/notification_screen.dart';
import 'package:dar_elteb/shared/components/cached_network_image.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';
import 'package:dar_elteb/tech_lib/tech_models/reservation_model.dart';
import 'package:dar_elteb/tech_lib/tech_screens/reserved_screens/reservation_details_screen.dart';
import 'package:dar_elteb/tech_lib/tech_screens/tech_map_screen.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class TechGeneralHomeLayoutAppBar extends StatelessWidget
    with PreferredSizeWidget {
  const TechGeneralHomeLayoutAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppTechCubit.get(context);
        return Column(
          children: [
            AppBar(
              backgroundColor: greyExtraLightColor,
              elevation: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    radius: 15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: AppTechCubit.get(context)
                                .userResourceModel
                                ?.data
                                ?.profile ??
                            '',
                        fit: BoxFit.cover,
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
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  horizontalMiniSpace,
                  Expanded(
                    child: Text(
                      '${cubit.userResourceModel?.data?.name ?? ''} ,',
                      textAlign: TextAlign.start,
                      style: titleSmallStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      FadeRoute(
                        page: const NotificationScreen(),
                      ),
                    );
                  },
                  icon: const ImageIcon(
                    AssetImage('assets/images/notification.png'),
                    color: mainColor,
                  ),
                ),
                horizontalMicroSpace
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: greyDarkColor,
                  ),
                  horizontalMiniSpace,
                  Text(
                    '${LocaleKeys.txtBranch.tr()} :    ',
                    style: titleSmallStyle,
                  ),
                  Expanded(
                    child: Text(AppTechCubit.get(context)
                            .userResourceModel
                            ?.data
                            ?.branch
                            ?.title ??
                        ''),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86);
}

class TechHomeRequestsCart extends StatelessWidget {
  const TechHomeRequestsCart({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var techRequests =
            AppTechCubit.get(context).techRequestsModel?.data?[index];
        return Container(
          height: 260.0,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 1,
              color: greyLightColor,
            ),
          ),
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('#${techRequests?.id ?? 0}'),
                  const Spacer(),
                  Text(
                    '${techRequests?.price} ${LocaleKeys.salary.tr()}',
                    style: titleSmallStyle,
                  ),
                ],
              ),
              Text('${techRequests?.date}'),
              myHorizontalDivider(),
              Row(
                children: [
                  CachedNetworkImageCircular(
                    imageUrl: '${techRequests?.patient?.profile}',
                    height: 65,
                  ),

                  horizontalMiniSpace,
                  Text(
                    '${techRequests?.patient?.name}',
                    textAlign: TextAlign.center,
                    style: titleSmallStyle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              verticalMicroSpace,
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: greyDarkColor,
                    ),
                    horizontalMiniSpace,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${techRequests?.address?.address}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: TechMapScreen(
                                      lat: techRequests?.address?.latitude,
                                      long: techRequests?.address?.longitude),
                                ),
                              );
                            },
                            child: Text(
                              LocaleKeys.txtShowMap.tr(),
                              style: titleSmallStyle2.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: mainColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    horizontalMiniSpace,
                  ],
                ),
              ),
              myHorizontalDivider(),
              ConditionalBuilder(
                condition: state is! AppAcceptRequestsLoadingState,
                builder: (context) => GeneralButton(
                  height: 40.0,
                  title: LocaleKeys.BtnAccept.tr(),
                  onPress: () {
                    AppTechCubit.get(context)
                        .acceptRequest(requestId: techRequests!.id);
                  },
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TechHomeReservationsCart extends StatelessWidget {
  TechHomeReservationsCart(
      {Key? key, required this.index, this.techReservationsDataModel})
      : super(key: key);
  final int index;
  List<TechReservationsDataModel>? techReservationsDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var techReservations = techReservationsDataModel?[index] ??
            techReservationsDataModel!.first;
        Color stateColor;
        if (techReservations.statusEn == 'Pending') {
          stateColor = pendingColor;
        } else if (techReservations.statusEn == 'Accepted') {
          stateColor = acceptedColor;
        } else if (techReservations.statusEn == 'Sampling') {
          stateColor = samplingColor;
        } else if (techReservations.statusEn == 'Finished') {
          stateColor = finishedColor;
        } else {
          stateColor = canceledColor;
        }
        String image;
        if (techReservations.tests != null) {
          image = techReservations.tests?.first.image;
        } else if (techReservations.offers != null) {
          image = techReservations.offers?.first.image;
        } else {
          image = imageTest;
        }
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                FadeRoute(
                    page: TechReservationsDetailsScreen(
                  techReservationsDataModel: techReservations,
                  index: index,
                )));
          },
          child: Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                width: 1,
                color: greyLightColor,
              ),
            ),
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('#${techReservations.id}'),
                    const Spacer(),
                    Text(
                      '${techReservations.price} ${LocaleKeys.salary.tr()}',
                      style: titleSmallStyle,
                    ),
                  ],
                ),
                // const Text(
                //   'name',
                //   style: titleSmallStyle,
                // ),
                Text('${techReservations.date}'),
                verticalMicroSpace,
                Container(
                  height: 36,
                  width: 130,
                  decoration: BoxDecoration(
                    color: stateColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                      child: Text(
                    '${techReservations.status}',
                    style: titleStyle.copyWith(
                        fontSize: 15.0,
                        color: stateColor,
                        fontWeight: FontWeight.normal),
                  )),
                ),
                myHorizontalDivider(),
                Row(
                  children: [
                    CachedNetworkImageCircular(
                      imageUrl: image,
                      height: 55,
                    ),
                    horizontalMiniSpace,
                    Text(
                      '${techReservations.patient?.name}',
                      textAlign: TextAlign.center,
                      style: titleSmallStyle2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: greyDarkColor,
                      ),
                      horizontalMiniSpace,
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${techReservations.address?.address}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: TechMapScreen(
                                        lat: techReservations.address?.latitude,
                                        long: techReservations
                                            .address?.longitude),
                                  ),
                                );
                              },
                              child: Text(
                                LocaleKeys.txtShowMap.tr(),
                                style: titleSmallStyle2.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: mainColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      horizontalMiniSpace,
                    ],
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

class ReservedAcceptedSubScreen extends StatelessWidget {
  const ReservedAcceptedSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: AppTechCubit.get(context)
              .techReservationsAcceptedModel
              ?.isEmpty ==
              false,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TechHomeReservationsCart(
                index: index,
                techReservationsDataModel:
                    AppTechCubit.get(context).techReservationsAcceptedModel!,
              ),
            ),
            separatorBuilder: (context, index) => verticalMiniSpace,
            itemCount: AppTechCubit.get(context)
                    .techReservationsAcceptedModel
                    ?.length ??
                0,
          ),
          fallback: (context) => ScreenHolder(msg: LocaleKeys.txtReservations.tr()),
        );
      },
    );
  }
}

class ReservedSamplingSubScreen extends StatelessWidget {
  const ReservedSamplingSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
          AppTechCubit.get(context)
              .techReservationsSamplingModel
              ?.isEmpty ==
              false,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TechHomeReservationsCart(
                index: index,
                techReservationsDataModel:
                    AppTechCubit.get(context).techReservationsSamplingModel!,
              ),
            ),
            separatorBuilder: (context, index) => verticalMiniSpace,
            itemCount: AppTechCubit.get(context)
                    .techReservationsSamplingModel
                    ?.length ??
                0,
          ),
          fallback: (context) => ScreenHolder(msg: LocaleKeys.txtReservations.tr()),
        );
      },
    );
  }
}

class ReservedCanceledSubScreen extends StatelessWidget {
  const ReservedCanceledSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
          AppTechCubit.get(context)
              .techReservationsCanceledModel
              ?.isEmpty ==
              false,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TechHomeReservationsCart(
                index: index,
                techReservationsDataModel:
                    AppTechCubit.get(context).techReservationsCanceledModel!,
              ),
            ),
            separatorBuilder: (context, index) => verticalMiniSpace,
            itemCount: AppTechCubit.get(context)
                    .techReservationsCanceledModel
                    ?.length ??
                0,
          ),
          fallback: (context) => ScreenHolder(msg: LocaleKeys.txtReservations.tr()),
        );
      },
    );
  }
}

class ReservedFinishingSubScreen extends StatelessWidget {
  const ReservedFinishingSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
          AppTechCubit.get(context)
              .techReservationsFinishedModel
              ?.isEmpty ==
              false,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TechHomeReservationsCart(
                index: index,
                techReservationsDataModel:
                    AppTechCubit.get(context).techReservationsFinishedModel!,
              ),
            ),
            separatorBuilder: (context, index) => verticalMiniSpace,
            itemCount: AppTechCubit.get(context)
                    .techReservationsFinishedModel
                    ?.length ??
                0,
          ),
          fallback: (context) => ScreenHolder(msg: LocaleKeys.txtReservations.tr()),
        );
      },
    );
  }
}

class TechUserRequestsCart extends StatelessWidget {
  const TechUserRequestsCart({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var techRequests =
            AppTechCubit.get(context).techUserRequestModel?.data?[index];
        return Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 1,
              color: greyLightColor,
            ),
          ),
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('#${techRequests?.id ?? 0}'),
                  const Spacer(),
                ],
              ),
              Text('${techRequests?.date?.date} - ${techRequests?.date?.time}'),
              myHorizontalDivider(),
              verticalMicroSpace,
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: greyDarkColor,
                    ),
                    horizontalMiniSpace,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${techRequests?.address?.address}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: TechMapScreen(
                                      lat: techRequests?.address?.latitude,
                                      long: techRequests?.address?.longitude),
                                ),
                              );
                            },
                            child: Text(
                              LocaleKeys.txtShowMap.tr(),
                              style: titleSmallStyle2.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: mainColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    horizontalMiniSpace,
                  ],
                ),
              ),
              GeneralButton(
                height: 40.0,
                title: LocaleKeys.BtnAccept.tr(),
                onPress: () {
                  AppTechCubit.get(context)
                      .acceptTechRequest(techRequest: techRequests!.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
