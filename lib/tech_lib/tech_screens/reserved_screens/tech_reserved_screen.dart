import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/models/model_test.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/tech_lib/tech_components.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TechReservedScreen extends StatefulWidget {
  const TechReservedScreen({Key? key}) : super(key: key);

  @override
  State<TechReservedScreen> createState() => _TechReservedScreenState();
}

class _TechReservedScreenState extends State<TechReservedScreen> {
  String selectedDate = '';
  String dateCount = '';
  String range = '';
  String rangeCount = '';

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        dateCount = args.value.length.toString();
      } else {
        rangeCount = args.value.length.toString();
      }
    });
  }

  Color bgColorAll = whiteColor;
  Color bgColorUpcoming = mainColor;
  Color bgColorSampling = mainColor;
  Color bgColorCanceled = mainColor;
  Color bgColorFinished = mainColor;
  Color fontColorAll = mainColor;
  Color fontColorUpcoming = whiteColor;
  Color fontColorSampling = whiteColor;
  Color fontColorCanceled = whiteColor;
  Color fontColorFinished = whiteColor;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {
        if (state is AppGetTechReservationsSuccessState) {
          if (state.techReservationsModel.status) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        } else if (state is AppGetTechReservationsErrorState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        bgColorAll =
        index == 0 ? mainLightColor : whiteColor;
        bgColorUpcoming =
        index == 1 ? mainLightColor : whiteColor;
        bgColorSampling =
        index == 2 ? mainLightColor : whiteColor;
        bgColorCanceled =
        index == 3 ? mainLightColor : whiteColor;
        bgColorFinished =
        index == 4 ? mainLightColor : whiteColor;
        fontColorAll =
        index == 0 ? whiteColor : mainLightColor;
        fontColorUpcoming =
        index == 1 ? whiteColor : mainLightColor;
        fontColorSampling =
        index == 2 ? whiteColor : mainLightColor;
        fontColorCanceled =
        index == 3 ? whiteColor : mainLightColor;
        fontColorFinished =
        index == 4 ? whiteColor : mainLightColor;
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: const TechGeneralHomeLayoutAppBar(),
          body: DefaultTabController(
            length: 5,
            child: Scaffold(
              backgroundColor: greyExtraLightColor,
              body: Column(
                children: <Widget>[
                  // the tab bar with two items
                  Container(
                    height: 58,
                    decoration: const BoxDecoration(color: greyExtraLightColor),
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: AppBar(
                      backgroundColor: greyExtraLightColor,
                      elevation: 0.0,
                      bottom: TabBar(
                        isScrollable: true,
                        physics: const BouncingScrollPhysics(),
                        indicator: const BoxDecoration(),
                        onTap: (i) {
                          setState(() {
                          index = i;
                          });
                        },
                        tabs: [
                          Tab(
                            child: Container(
                              height: 55,
                              width: 100,
                              decoration: BoxDecoration(
                                color: bgColorAll,
                                borderRadius: BorderRadius.circular(radius),
                                border:
                                    Border.all(width: 1, color: greyLightColor),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.txtAll.tr(),
                                  style: titleSmallStyle.copyWith(
                                    color: fontColorAll,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              height: 55,
                              width: 100,
                              decoration: BoxDecoration(
                                color: bgColorUpcoming,
                                borderRadius: BorderRadius.circular(radius),
                                border:
                                    Border.all(width: 1, color: greyLightColor),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.txtUpcoming.tr(),
                                  style: titleSmallStyle.copyWith(
                                    color: fontColorUpcoming,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              height: 55,
                              width: 100,
                              decoration: BoxDecoration(
                                color: bgColorSampling,
                                borderRadius: BorderRadius.circular(radius),
                                border:
                                    Border.all(width: 1, color: greyLightColor),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.txtSampling.tr(),
                                  style: titleSmallStyle.copyWith(
                                      color: fontColorSampling),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              height: 55,
                              width: 100,
                              decoration: BoxDecoration(
                                color: bgColorCanceled,
                                borderRadius: BorderRadius.circular(radius),
                                border:
                                    Border.all(width: 1, color: greyLightColor),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.txtCanceled.tr(),
                                  style: titleSmallStyle.copyWith(
                                      color: fontColorCanceled),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              height: 55,
                              width: 100,
                              decoration: BoxDecoration(
                                color: bgColorFinished,
                                borderRadius: BorderRadius.circular(radius),
                                border:
                                    Border.all(width: 1, color: greyLightColor),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.completeTxtMain.tr(),
                                  style: titleSmallStyle.copyWith(
                                      color: fontColorFinished),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // create widgets for each tab bar here
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // first tab bar view widget
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      LocaleKeys.txtTestList.tr(),
                                      style: titleSmallStyle,
                                    ),
                                    const Spacer(),
                                    GeneralUnfilledButton(
                                      width: 100,
                                      height: 40.0,
                                      title: LocaleKeys.txtTestDate.tr(),
                                      onPress: () {
                                        showCustomBottomSheet(
                                          context,
                                          bottomSheetContent:
                                          const SyncfusionFlutterDatePicker(),
                                          bottomSheetHeight: 0.65,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              verticalMiniSpace,
                              ConditionalBuilder(
                                condition: AppTechCubit.get(context)
                                    .techReservationsModel
                                    ?.data
                                    ?.isEmpty ==
                                    false,
                                builder: (context) => ConditionalBuilder(
                                  condition: state
                                  is! AppGetTechReservationsLoadingState,
                                  builder: (context) => Expanded(
                                    child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TechHomeReservationsCart(
                                          index: index,
                                          techReservationsDataModel:
                                          AppTechCubit.get(context)
                                              .techReservationsModel!
                                              .data!,
                                        ),
                                      ),
                                      separatorBuilder: (context, index) =>
                                      verticalMiniSpace,
                                      itemCount: AppTechCubit.get(context)
                                          .techReservationsModel
                                          ?.data
                                          ?.length ??
                                          0,
                                    ),
                                  ),
                                  fallback: (context) => const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                ),
                                fallback: (context) => Expanded(
                                  child: Center(
                                      child: ScreenHolder(
                                        msg: LocaleKeys.txtReservations.tr(),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          // second tab bar view widget
                          const ReservedAcceptedSubScreen(),
                          // third tab bar view widget
                          const ReservedSamplingSubScreen(),
                          // fourth tab bar view widget
                          const ReservedCanceledSubScreen(),
                          // fifth tab bar view widget
                          const ReservedFinishingSubScreen(),
                        ],
                      ),
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
