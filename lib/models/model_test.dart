import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SyncfusionFlutterDatePicker extends StatefulWidget {
   const SyncfusionFlutterDatePicker({Key? key,}) : super(key: key);

  @override
  SyncfusionFlutterDatePickerState createState() =>
      SyncfusionFlutterDatePickerState();
}

/// State for SyncfusionFlutterDatePicker
class SyncfusionFlutterDatePickerState
    extends State<SyncfusionFlutterDatePicker> {
  String selectedDate = '';

  String dateCount = '';

  String rangeCount = '';

  String range = '';

  String dateFrom = '';

  String dateTo = '';

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} -'
            ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
        dateFrom = DateFormat('yyyy-MM-dd').format(
            args.value.startDate ?? kToday.year - kToday.month - kToday.day);
        dateTo = DateFormat('yyyy-MM-dd').format(
            args.value.endDate ?? kToday.year - kToday.month - kToday.day);
        // AppTechCubit.get(context).getReservations(
        //   dateFrom: DateFormat('yyyy-MM-dd').format(args.value.startDate),
        //   dateTo: DateFormat('yyyy-MM-dd')
        //       .format(args.value.endDate ?? args.value.startDate),
        // );
      } else if (args.value is DateTime) {
        selectedDate = args.value.toString();
        // AppTechCubit.get(context).getReservations(dateFrom: selectedDate);
      } else if (args.value is List<DateTime>) {
        dateCount = args.value.length.toString();
      } else {
        rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.txtDateRange.tr(),
                        style: titleSmallStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(range),
            SfDateRangePicker(
              onSelectionChanged: onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
            ConditionalBuilder(
              condition: state is! AppGetTechReservationsLoadingState,
              builder: (context) => GeneralButton(
                title: LocaleKeys.BtnSubmit.tr(),
                onPress: () {
                  AppTechCubit.get(context)
                      .getReservations(dateFrom: dateFrom, dateTo: dateTo);
                },
              ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ],
        );
      },
    );
  }
}



class SyncfusionPatientLabReservationsDatePicker extends StatefulWidget {
  const SyncfusionPatientLabReservationsDatePicker({Key? key,}) : super(key: key);

  @override
  SyncfusionPatientLabReservationsDatePickerState createState() =>
      SyncfusionPatientLabReservationsDatePickerState();
}

/// State for SyncfusionPatientLabReservationsDatePicker
class SyncfusionPatientLabReservationsDatePickerState
    extends State<SyncfusionPatientLabReservationsDatePicker> {

  String selectedDate = '';

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
       if (args.value is DateTime) {
         DateTime data;
        data = args.value;
        String day = data.day.toString();
        String month = data.month.toString();
        if (day.length == 1){
          day = '0$day';
        }
        if (month.length == 1){
          month = '0$month';
        }
         selectedDate = '${data.year}/$month/$day';
        print(selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Text(selectedDate,style: titleStyle.copyWith(color: mainColor)),
            SfDateRangePicker(
              onSelectionChanged: onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.single,
            ),
            ConditionalBuilder(
              condition: state is! AppGetTechReservationsLoadingState,
              builder: (context) => GeneralButton(
                title: LocaleKeys.BtnSubmit.tr(),
                onPress: () {
                  print('date $selectedDate');
                  AppCubit.get(context).getLabReservations(date: selectedDate);
                  Navigator.pop(context);
                },
              ),
              fallback: (context) =>
              const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ],
        );
      },
    );
  }
}



class SyncfusionPatientHomeReservationsDatePicker extends StatefulWidget {
  const SyncfusionPatientHomeReservationsDatePicker({Key? key,}) : super(key: key);

  @override
  SyncfusionPatientHomeReservationsDatePickerState createState() =>
      SyncfusionPatientHomeReservationsDatePickerState();
}

/// State for SyncfusionPatientHomeReservationsDatePicker
class SyncfusionPatientHomeReservationsDatePickerState
    extends State<SyncfusionPatientHomeReservationsDatePicker> {

  String selectedDate = '';

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
       if (args.value is DateTime) {
         DateTime data;
        data = args.value;
        String day = data.day.toString();
        String month = data.month.toString();
        if (day.length == 1){
          day = '0$day';
        }
        if (month.length == 1){
          month = '0$month';
        }
         selectedDate = '${data.year}/$month/$day';
        print(selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Text(selectedDate,style: titleStyle.copyWith(color: mainColor)),
            SfDateRangePicker(
              onSelectionChanged: onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.single,
            ),
            ConditionalBuilder(
              condition: state is! AppGetTechReservationsLoadingState,
              builder: (context) => GeneralButton(
                title: LocaleKeys.BtnSubmit.tr(),
                onPress: () {
                  print('date $selectedDate');
                  AppCubit.get(context).getHomeReservations(date: selectedDate);
                  Navigator.pop(context);
                },
              ),
              fallback: (context) =>
              const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ],
        );
      },
    );
  }
}