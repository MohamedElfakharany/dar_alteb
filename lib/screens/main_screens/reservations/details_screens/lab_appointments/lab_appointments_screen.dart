// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/test_models/offers_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/tests_model.dart';
import 'package:dar_elteb/screens/main_screens/reservations/details_screens/lab_appointments/lab_reservation_details_screen.dart';
import 'package:dar_elteb/screens/main_screens/reservations/widget_components.dart';
import 'package:dar_elteb/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class LabAppointmentsScreen extends StatelessWidget {
  LabAppointmentsScreen({Key? key, this.offersDataModel, this.testsDataModel})
      : super(key: key);
  TestsDataModel? testsDataModel;
  OffersDataModel? offersDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AppCubit()..getLabAppointments(date: '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var labAppointmentModel = cubit.labAppointmentsModel;
          print('testsDataModel : ${testsDataModel?.id}');
          print('offersDataModel : ${offersDataModel?.id}');
          return Scaffold(
            backgroundColor: greyExtraLightColor,
            appBar: GeneralAppBar(
              title: LocaleKeys.txtLabReservation.tr(),
              centerTitle: false,
              appBarColor: greyExtraLightColor,
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const LabCalenderView(),
                verticalSmallSpace,
                ConditionalBuilder(
                  condition: state is! AppGetLabAppointmentsLoadingState,
                  builder: (context) => ConditionalBuilder(
                    condition: labAppointmentModel != null,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 3 / 1,
                        children: List.generate(
                          labAppointmentModel?.data?.length ?? 0,
                          (index) => InkWell(
                            onTap: () {
                              if (labAppointmentModel?.data?[index].isUsed) {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: LabReservationDetailsScreen(
                                      testsDataModel: testsDataModel,
                                      offersDataModel: offersDataModel,
                                      time: labAppointmentModel?.data?[index].time24,
                                      date: labAppointmentModel?.extra?.date.toString() ?? '',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: LabAppointmentsCard(
                              labAppointmentsDataModel:
                                  labAppointmentModel?.data?[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    fallback: (context) => ScreenHolder(
                        msg: LocaleKeys.AppointmentScreenTxtTitle.tr()),
                  ),
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
