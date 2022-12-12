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

class TechRequestsScreen extends StatefulWidget {
  const TechRequestsScreen({Key? key}) : super(key: key);

  @override
  State<TechRequestsScreen> createState() => _TechRequestsScreenState();
}

class _TechRequestsScreenState extends State<TechRequestsScreen> {
  Color bgColorTest = whiteColor;
  Color bgColorOffer = mainColor;
  Color fontColorTest = mainColor;
  Color fontColorOffer = whiteColor;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    var cubit = AppTechCubit.get(context);
    bgColorTest = index == 0 ? mainLightColor : whiteColor;
    bgColorOffer = index == 1 ? mainLightColor : whiteColor;
    fontColorTest = index == 1 ? mainLightColor : whiteColor;
    fontColorOffer = index == 0 ? mainLightColor : whiteColor;

    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: const TechGeneralHomeLayoutAppBar(),
          body: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: greyExtraLightColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    // the tab bar with two items
                    SizedBox(
                      height: 60,
                      child: AppBar(
                        backgroundColor: greyExtraLightColor,
                        elevation: 0.0,
                        bottom: TabBar(
                          indicator: const BoxDecoration(),
                          onTap: (i) {
                            setState(() {
                              index = i;
                            });
                          },
                          tabs: [
                            Tab(
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: mainLightColor, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  color: bgColorTest,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/atLabIcon.png',
                                      width: 25,
                                      height: 25,
                                      color: fontColorTest,
                                    ),
                                    horizontalMiniSpace,
                                    Text(
                                      LocaleKeys.BtnAtLab.tr(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: fontColorTest,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: mainLightColor, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  color: bgColorOffer,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/atHomeIcon.png',
                                      width: 25,
                                      height: 25,
                                      color: fontColorOffer,
                                    ),
                                    horizontalMiniSpace,
                                    Text(
                                      LocaleKeys.BtnAtHome.tr(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: fontColorOffer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // create widgets for each tab bar here
                    verticalMiniSpace,
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // first tab bar view widget
                          ConditionalBuilder(
                            condition:
                                cubit.techRequestsModel?.data?.isNotEmpty ==
                                    true,
                            builder: (context) => ConditionalBuilder(
                              condition:
                                  state is! AppAcceptTechRequestsLoadingState,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) =>
                                      TechHomeRequestsCart(index: index),
                                  separatorBuilder: (context, index) =>
                                      verticalMiniSpace,
                                  itemCount: AppTechCubit.get(context)
                                          .techRequestsModel
                                          ?.data
                                          ?.length ??
                                      0,
                                ),
                              ),
                              fallback: (context) => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                            fallback: (context) => Center(
                              child: ScreenHolder(
                                  msg: LocaleKeys.txtRequests2.tr()),
                            ),
                          ),
                          // second tab bar view widget
                          ConditionalBuilder(
                            condition:
                                cubit.techUserRequestModel?.data?.isNotEmpty ==
                                    true,
                            builder: (context) => ConditionalBuilder(
                              condition:
                                  state is! AppAcceptTechRequestsLoadingState,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) =>
                                      TechUserRequestsCart(index: index),
                                  separatorBuilder: (context, index) =>
                                      verticalMiniSpace,
                                  itemCount: AppTechCubit.get(context)
                                          .techUserRequestModel
                                          ?.data
                                          ?.length ??
                                      0,
                                ),
                              ),
                              fallback: (context) => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                            fallback: (context) => Center(
                              child: ScreenHolder(
                                  msg: LocaleKeys.txtRequests2.tr()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
