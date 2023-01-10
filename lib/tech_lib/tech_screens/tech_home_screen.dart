import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/tech_lib/tech_components.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class TechHomeScreen extends StatefulWidget {
  const TechHomeScreen({Key? key}) : super(key: key);

  @override
  State<TechHomeScreen> createState() => _TechHomeScreenState();
}

class _TechHomeScreenState extends State<TechHomeScreen> {
  @override
  void initState() {
    super.initState();
    AppTechCubit.get(context).getProfile();
    AppTechCubit.get(context).getRequests();
    AppTechCubit.get(context).getReservations();
    AppTechCubit.get(context).getUserRequest();
    AppTechCubit.get(context).getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppTechCubit.get(context);
    return BlocProvider(
      create: (BuildContext context) => AppTechCubit()
        ..getProfile()
        ..getRequests()
        ..getReservations()
        ..getUserRequest()
        ..getNotifications(),
      child: BlocConsumer<AppTechCubit, AppTechStates>(
        listener: (context, state) {
          if (state is AppAcceptRequestsSuccessState) {
            if (state.successModel.status) {
              showToast(
                  msg: state.successModel.message, state: ToastState.success);
            } else {}
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: greyExtraLightColor,
            appBar: const TechGeneralHomeLayoutAppBar(),
            body: ConditionalBuilder(
              condition: state is! AppTechGetProfileLoadingState &&
                  state is! AppGetTechRequestsLoadingState &&
                  state is! AppGetTechReservationsLoadingState,
              builder: (context) => Container(
                color: greyExtraLightColor,
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    verticalSmallSpace,
                    Row(
                      children: [
                        Text(
                          LocaleKeys.txtTestCategories.tr(),
                          style: titleStyle,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(
                              () {
                                cubit.changeBottomScreen(1);
                              },
                            );
                          },
                          child: Text(
                            LocaleKeys.BtnSeeAll.tr(),
                            style: subTitleSmallStyle,
                          ),
                        ),
                      ],
                    ),
                    verticalMiniSpace,
                    ConditionalBuilder(
                      condition: cubit.techUserRequestModel?.data?.length != [],
                      builder: (context) => SizedBox(
                        height: 265.0,
                        width: double.infinity,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              TechHomeRequestsCart(index: index),
                          separatorBuilder: (context, index) =>
                              horizontalMiniSpace,
                          itemCount: AppTechCubit.get(context)
                                  .techRequestsModel
                                  ?.data
                                  ?.length ??
                              0,
                        ),
                      ),
                      fallback: (context) => Center(
                        child: ScreenHolder(msg: LocaleKeys.txtRequests2.tr()),
                      ),
                    ),
                    verticalMediumSpace,
                    Row(
                      children: [
                        Text(
                          LocaleKeys.txtLastReservations.tr(),
                          style: titleStyle,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              cubit.changeBottomScreen(2);
                            });
                          },
                          child: Text(
                            LocaleKeys.BtnSeeAll.tr(),
                            style: subTitleSmallStyle,
                          ),
                        ),
                      ],
                    ),
                    verticalMiniSpace,
                    ConditionalBuilder(
                      condition:
                          cubit.techReservationsModel?.data?.length != [],
                      builder: (context) => SizedBox(
                        height: 240.0,
                        width: double.infinity,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              TechHomeReservationsCart(
                            index: index,
                            techReservationsDataModel: AppTechCubit.get(context)
                                .techReservationsModel!
                                .data![index],
                          ),
                          separatorBuilder: (context, index) =>
                              horizontalMiniSpace,
                          itemCount: AppTechCubit.get(context)
                                  .techReservationsModel
                                  ?.data
                                  ?.length ??
                              0,
                        ),
                      ),
                      fallback: (context) => Center(
                        child:
                            ScreenHolder(msg: LocaleKeys.txtReservations.tr()),
                      ),
                    ),
                    verticalMediumSpace,
                  ],
                ),
              ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        },
      ),
    );
  }
}
