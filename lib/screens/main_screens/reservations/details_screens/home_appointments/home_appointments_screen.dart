// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/test_models/offers_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/tests_model.dart';
import 'package:dar_elteb/screens/main_screens/reservations/details_screens/home_appointments/home_reservation_details_screen.dart';
import 'package:dar_elteb/screens/main_screens/reservations/widget_components.dart';
import 'package:dar_elteb/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class HomeAppointmentsScreen extends StatelessWidget {
  HomeAppointmentsScreen({Key? key,this.offersDataModel, this.testsDataModel})
      : super(key: key);
  TestsDataModel? testsDataModel;
  OffersDataModel? offersDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      AppCubit()..getHomeAppointments(date: '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var homeAppointmentsModel = cubit.homeAppointmentsModel;
          return Scaffold(
            backgroundColor: greyExtraLightColor,
            appBar: GeneralAppBar(
              title: LocaleKeys.txtHomeReservation.tr(),
              centerTitle: false,
              appBarColor: greyExtraLightColor,
            ),
            body: Column(
              children: [
                const HomeCalenderView(),
                verticalSmallSpace,
                Expanded(
                  child: ConditionalBuilder(
                    condition: state is! AppGetHomeAppointmentsLoadingState,
                    builder: (context) => ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          if (AppCubit.get(context).homeAppointmentsModel?.data?[index].isUsed){
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: HomeReservationDetailsScreen(
                                testsDataModel: testsDataModel,
                                offersDataModel: offersDataModel,
                                time: homeAppointmentsModel?.data?[index].from24,
                                date: homeAppointmentsModel?.extra?.date.toString() ?? '',
                              ),
                            ),
                          );
                          }
                        },
                        child: HomeAppointmentsCard(homeAppointmentsModel: AppCubit.get(context).homeAppointmentsModel,index: index),
                      ),
                      separatorBuilder: (context, index) => verticalSmallSpace,
                      itemCount: AppCubit.get(context).homeAppointmentsModel?.data?.length ?? 0,
                    ),
                    fallback: (context) => const Center (child: CircularProgressIndicator.adaptive(),) ,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
