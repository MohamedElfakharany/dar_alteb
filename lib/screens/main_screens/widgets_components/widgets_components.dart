// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/profile_models/notifications_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/categories_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/offers_model.dart';
import 'package:dar_elteb/models/patient_models/test_models/tests_model.dart';
import 'package:dar_elteb/screens/intro_screens/startup/onboarding_screen.dart';
import 'package:dar_elteb/screens/main_screens/card_screen.dart';
import 'package:dar_elteb/screens/main_screens/home_layout_screen.dart';
import 'package:dar_elteb/screens/main_screens/test_items_screen/test_details_screen.dart';
import 'package:dar_elteb/shared/components/cached_network_image.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:table_calendar/table_calendar.dart';

class LabCalenderView extends StatefulWidget {
  const LabCalenderView({
    Key? key,
  }) : super(key: key);

  @override
  _LabCalenderViewState createState() => _LabCalenderViewState();
}

class _LabCalenderViewState extends State<LabCalenderView> {
  // final DateTime _currentDay = DateTime.now();
  final DateTime _today = DateTime.now();
  DateTime? _selectedDay;

  dynamic day;
  dynamic month;

  final CalendarFormat _calendarFormat = CalendarFormat.month;

  // List<SessionModel> _getEventsForDay(DateTime day) {
  //   return [];
  // }
  // final bool _loadingData = true;
  // final bool _isCurrentMonthChanged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: whiteColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10.0),
                    child: TableCalendar(
                      locale: sharedLanguage,
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _today,
                      calendarFormat: _calendarFormat,
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      daysOfWeekHeight: 30,
                      rowHeight: 40,
                      // eventLoader: _getEventsForDay,
                      // for badge under day
                      selectedDayPredicate: (day) {
                        // Use `selectedDayPredicate` to determine which day is currently selected.
                        // If this returns true, then `day` will be marked as selected.

                        // Using `isSameDay` is recommended to disregard
                        // the time-part of compared DateTime objects.
                        return isSameDay(_selectedDay, day);
                      },
                      onFormatChanged: (format) {
                        // if (_calendarFormat == CalendarFormat.month) {
                        //   setState(() {
                        //     _calendarFormat = CalendarFormat.twoWeeks;
                        //   });
                        // }
                        // else if ( _calendarFormat == CalendarFormat.twoWeeks){
                        //   setState(() {
                        //     _calendarFormat = CalendarFormat.week;
                        //   });
                        // }
                        // else if (_calendarFormat == CalendarFormat.week){
                        //   setState(() {
                        //     _calendarFormat = CalendarFormat.month;
                        //   });
                        // }
                      },
                      onCalendarCreated: (controller) {
                        // Provider.of<ShiftsProvider>(context,listen: false).fetchCalendarDaysWithOffers(context,startDate: widget.startDate,endDate: widget.endDate,historyType: widget.historyType);
                      },
                      onPageChanged: (DateTime day) {
                        // to save current page in Calendar when page changed .
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          // Call `setState()` when updating the selected day
                          setState(() {
                            _selectedDay = selectedDay;
                          });
                        }
                        if (selectedDay.day <= 9) {
                          day = '0${selectedDay.day}';
                        } else {
                          day = selectedDay.day;
                        }

                        if (selectedDay.month <= 9) {
                          month = '0${selectedDay.month}';
                        } else {
                          month = selectedDay.month;
                        }

                        AppCubit.get(context).getLabAppointments(
                            date:
                                '${selectedDay.year.toString()}-${month.toString()}-${day.toString()}');
                      },
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },
                      headerStyle: HeaderStyle(
                        headerPadding: EdgeInsets.symmetric(horizontal: 0.2.sw),
                      ),
                      calendarStyle: const CalendarStyle(
                        selectedTextStyle:
                            TextStyle(color: whiteColor, fontSize: 20),
                        todayDecoration: BoxDecoration(),
                        todayTextStyle: TextStyle(
                            color: greenColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                        selectedDecoration: BoxDecoration(
                            color: greenColor, shape: BoxShape.circle),
                        defaultDecoration: BoxDecoration(),
                        holidayDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        weekendDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        rangeEndDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        outsideDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        disabledDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        // weekendTextStyle: TextStyle(
                        //   color: blueColor,
                        // ),
                        markerSize: 40.0,
                        markerDecoration: BoxDecoration(),
                        isTodayHighlighted: true,
                      ),
                      // formatAnimationCurve: Curves.easeIn,
                      availableGestures: AvailableGestures.horizontalSwipe,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeCalenderView extends StatefulWidget {
  const HomeCalenderView({Key? key}) : super(key: key);

  @override
  _HomeCalenderViewState createState() => _HomeCalenderViewState();
}

class _HomeCalenderViewState extends State<HomeCalenderView> {
  // final DateTime _currentDay = DateTime.now();
  final DateTime _today = DateTime.now();
  DateTime? _selectedDay;

  dynamic day;
  dynamic month;

  final CalendarFormat _calendarFormat = CalendarFormat.month;

  // List<SessionModel> _getEventsForDay(DateTime day) {
  //   return [];
  // }
  // final bool _loadingData = true;
  // final bool _isCurrentMonthChanged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: whiteColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10.0),
                    child: TableCalendar(
                      locale: sharedLanguage,
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _today,
                      calendarFormat: _calendarFormat,
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      daysOfWeekHeight: 30,
                      rowHeight: 40,
                      // eventLoader: _getEventsForDay,
                      // for badge under day
                      selectedDayPredicate: (day) {
                        // Use `selectedDayPredicate` to determine which day is currently selected.
                        // If this returns true, then `day` will be marked as selected.

                        // Using `isSameDay` is recommended to disregard
                        // the time-part of compared DateTime objects.
                        return isSameDay(_selectedDay, day);
                      },
                      onFormatChanged: (format) {
                        // if (_calendarFormat == CalendarFormat.month) {
                        //   setState(() {
                        //     _calendarFormat = CalendarFormat.twoWeeks;
                        //   });
                        // }
                        // else if ( _calendarFormat == CalendarFormat.twoWeeks){
                        //   setState(() {
                        //     _calendarFormat = CalendarFormat.week;
                        //   });
                        // }
                        // else if (_calendarFormat == CalendarFormat.week){
                        //   setState(() {
                        //     _calendarFormat = CalendarFormat.month;
                        //   });
                        // }
                      },

                      onCalendarCreated: (controller) {
                        // Provider.of<ShiftsProvider>(context,listen: false).fetchCalendarDaysWithOffers(context,startDate: widget.startDate,endDate: widget.endDate,historyType: widget.historyType);
                      },

                      onPageChanged: (DateTime day) {
                        // to save current page in Calendar when page changed .
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          // Call `setState()` when updating the selected day
                          setState(() {
                            _selectedDay = selectedDay;
                          });
                        }
                        if (selectedDay.day <= 9) {
                          day = '0${selectedDay.day}';
                        } else {
                          day = selectedDay.day;
                        }

                        if (selectedDay.month <= 9) {
                          month = '0${selectedDay.month}';
                        } else {
                          month = selectedDay.month;
                        }

                        AppCubit.get(context).getHomeAppointments(
                            date:
                                '${selectedDay.year.toString()}-${month.toString()}-${day.toString()}');
                      },
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },
                      headerStyle: HeaderStyle(
                        headerPadding: EdgeInsets.symmetric(horizontal: 0.2.sw),
                        // rightChevronIcon: Transform.rotate(
                        //     angle: Provider.of<LocalizationController>(context,
                        //                     listen: false)
                        //                 .locale
                        //                 .languageCode ==
                        //             "ar"
                        //         ? rightRotationAngle
                        //         : leftRotationAngle,
                        //     child: SvgPicture.asset("assets/dropDownArrow.svg",
                        //         color: greenBlue, height: 0.03.sw)),
                        // leftChevronIcon: Transform.rotate(
                        //     angle: Provider.of<LocalizationController>(context,
                        //                     listen: false)
                        //                 .locale
                        //                 .languageCode ==
                        //             "ar"
                        //         ? leftRotationAngle
                        //         : rightRotationAngle,
                        //     child: SvgPicture.asset("assets/dropDownArrow.svg",
                        //         color: greenBlue, height: 0.03.sw)),
                      ),
                      calendarStyle: const CalendarStyle(
                        selectedTextStyle:
                            TextStyle(color: whiteColor, fontSize: 20),
                        todayDecoration: BoxDecoration(),
                        todayTextStyle: TextStyle(
                            color: greenColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                        selectedDecoration: BoxDecoration(
                            color: greenColor, shape: BoxShape.circle),
                        defaultDecoration: BoxDecoration(),
                        holidayDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        weekendDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        rangeEndDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        outsideDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        disabledDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        // weekendTextStyle: TextStyle(
                        //   color: blueColor,
                        // ),
                        markerSize: 40.0,
                        markerDecoration: BoxDecoration(),
                        isTodayHighlighted: true,
                      ),
                      // formatAnimationCurve: Curves.easeIn,
                      availableGestures: AvailableGestures.horizontalSwipe,
                      // calendarBuilders: CalendarBuilders<SessionModel>(
                      //   dowBuilder: (context, day) {
                      //     return Center(
                      //       child: ExcludeSemantics(
                      //         child: Text(
                      //           "${DateFormat.E("en").format(day)}",
                      //           style: TextStyle(
                      //               color: !_isCurrentMonthChanged &&
                      //                       DateFormat.E("en_US").format(_today) ==
                      //                           DateFormat.E("en_US").format(day)
                      //                   ? Theme.of(context).primaryColor
                      //                   : dustyTeal,
                      //               fontWeight: FontWeight.w400),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        );
      },
    );
  }
}

class OffersCard extends StatelessWidget {
  const OffersCard({Key? key, required this.offersDataModel}) : super(key: key);
  final OffersDataModel offersDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 235,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 165,
                width: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    CachedNetworkImageNormal(
                      imageUrl: offersDataModel.image,
                      height: 165,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: redColor,
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            child: const Center(
                              child: Text(
                                '%',
                                style: TextStyle(color: whiteColor),
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (offersDataModel.gender == 'Male')
                            Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                color: mainLightColor,
                                borderRadius: BorderRadius.circular(radius),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LocaleKeys.Male.tr(),
                                      style: TextStyle(color: whiteColor),
                                    ),
                                    horizontalMicroSpace,
                                    const Icon(
                                      Icons.male,
                                      color: whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            )
                          else if (offersDataModel.gender == 'Female')
                            Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                color: pinkColor,
                                borderRadius: BorderRadius.circular(radius),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LocaleKeys.Female.tr(),
                                      style: TextStyle(color: whiteColor),
                                    ),
                                    const Icon(
                                      Icons.female,
                                      color: whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  offersDataModel.title,
                  style: titleSmallStyle2,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(
                      '${offersDataModel.discount} ${LocaleKeys.salary.tr()}',
                      style: titleSmallStyle2,
                    ),
                    horizontalMiniSpace,
                    Text(
                      '${offersDataModel.price} ${LocaleKeys.salary.tr()}',
                      style: subTitleSmallStyle2.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({
    Key? key,
    required this.categoriesDataModel,
  }) : super(key: key);
  final CategoriesDataModel categoriesDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          height: 110.0,
          width: 110.0,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 1,
              color: greyDarkColor,
            ),
          ),
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              verticalMiniSpace,
              CachedNetworkImageNormal(
                imageUrl: categoriesDataModel.icon,
                width: 65,
                height: 65,
              ),
              verticalMicroSpace,
              Text(
                categoriesDataModel.title,
                textAlign: TextAlign.center,
                style: subTitleSmallStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class TestItemCard extends StatelessWidget {
  TestItemCard(
      {Key? key,
      required this.index,
      this.offersDataModel,
      this.testsDataModel})
      : super(key: key);
  TestsDataModel? testsDataModel;
  OffersDataModel? offersDataModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          height: 110.0,
          width: 110.0,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 1,
              color: greyDarkColor,
            ),
          ),
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Row(
                children: [
                  horizontalMicroSpace,
                  CachedNetworkImageNormal(
                    imageUrl:
                        AppCubit.get(context).testsModel?.data?[index].image ??
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
                          AppCubit.get(context)
                                  .testsModel
                                  ?.data?[index]
                                  .title ??
                              '',
                          style: titleStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          AppCubit.get(context)
                                  .testsModel
                                  ?.data?[index]
                                  .description ??
                              '',
                          style: subTitleSmallStyle2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              '${AppCubit.get(context).testsModel?.data?[index].price} ${LocaleKeys.salary.tr()}',
                              style: titleSmallStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              FadeRoute(
                                page: TestDetailsScreen(
                                    testsDataModel: AppCubit.get(context)
                                        .testsModel!
                                        .data?[index]),
                              ),
                            );
                          },
                          color: mainColor,
                          child: Text(
                            LocaleKeys.txtDetails.tr(),
                            style: titleSmallStyle.copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          horizontalMicroSpace,
                          if (AppCubit.get(context)
                                  .testsModel
                                  ?.data?[index]
                                  .gender ==
                              'Male')
                            const Center(
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: mainLightColor,
                                child: Icon(
                                  Icons.male,
                                  size: 25,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          if (AppCubit.get(context)
                                  .testsModel
                                  ?.data?[index]
                                  .gender ==
                              'Female')
                            const Center(
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: pinkColor,
                                child: Icon(
                                  Icons.female,
                                  size: 25,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        print("isVisitor : ${isVisitor}");
                        if (isVisitor == true) {
                          showPopUp(
                            context,
                            const VisitorHoldingPopUp(),
                          );
                        } else if (isVisitor == false) {
                          AppCubit.get(context).addToCart(
                              testId: AppCubit.get(context)
                                  .testsModel
                                  ?.data?[index]
                                  .id);
                        }else {
                          showPopUp(
                            context,
                            const VisitorHoldingPopUp(),
                          );
                        }
                      },
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: greyLightColor,
                        child: Icon(
                          Icons.add,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class VisitorHoldingPopUp extends StatelessWidget {
  const VisitorHoldingPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 365,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSmallSpace,
          Image.asset(
            appLogo,
            width: 150,
            height: 150,
          ),
          verticalLargeSpace,
          Text(
            LocaleKeys.txtPleaseSignInFirst.tr(),
            style: titleStyle,
          ),
          verticalLargeSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GeneralButton(
                title: LocaleKeys.BtnSignIn.tr(),
                onPress: () {
                  AppCubit.get(context).currentIndex = 0;
                  Navigator.pushAndRemoveUntil(
                      context,
                      FadeRoute(
                        page: OnBoardingScreen(),
                      ),
                      (route) => false);
                }),
          ),
          verticalLargeSpace,
        ],
      ),
    );
  }
}

class NotificationsCard extends StatefulWidget {
  const NotificationsCard({Key? key, required this.notificationsDataModel})
      : super(key: key);
  final NotificationsDataModel notificationsDataModel;

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {
  @override
  Widget build(BuildContext context) {
    Color containerColor = whiteColor;

    setState(() {
      if (widget.notificationsDataModel.isRead == 0) {
        containerColor = mainLightColor.withOpacity(0.1);
      } else {
        containerColor = whiteColor;
      }
    });

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          width: double.infinity,
          // height: 100.0,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(
              radius,
            ),
            border: Border.all(
              width: 1,
              color: greyLightColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: mainLightColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      radius,
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    size: 35.0,
                    color: mainColor,
                  ),
                ),
                horizontalSmallSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.notificationsDataModel.body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            '${widget.notificationsDataModel.date?.date} - ${widget.notificationsDataModel.date?.time}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: subTitleSmallStyle,
                          ),
                          TextButton(
                            child: Text(
                              LocaleKeys.BtnDelete.tr(),
                              style: titleSmallStyleRed,
                            ),
                            onPressed: () {
                              AppCubit.get(context).deleteNotifications(
                                  notificationId:
                                      '${widget.notificationsDataModel.id}');
                            },
                          ),
                        ],
                      ),
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
