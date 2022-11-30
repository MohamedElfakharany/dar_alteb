import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/test_items_screen/test_details_screen.dart';
import 'package:dar_elteb/screens/main_screens/test_items_screen/test_items_screen.dart';
import 'package:dar_elteb/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({Key? key}) : super(key: key);

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 0),
          () {
        AppCubit.get(context).getCategories();
        AppCubit.get(context).getOffers();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            initialIndex: cubit.tapIndex,
            child: Scaffold(
              backgroundColor: greyExtraLightColor,
              body: Column(
                children: <Widget>[
                  // the tab bar with two items
                  SizedBox(
                    height: 60,
                    child: AppBar(
                      backgroundColor: greyExtraLightColor,
                      elevation: 0.0,
                      bottom: TabBar(
                        indicatorColor: mainColor,
                        labelColor: mainColor,
                        unselectedLabelColor: mainLightColor,
                        labelStyle: titleStyle,
                        enableFeedback: true,
                        tabs: [
                          Tab(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: mainLightColor, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.grey.withOpacity(0.15),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      color: whiteColor,
                                    ),
                                    child: Row(
                                      children: [
                                        horizontalMiniSpace,
                                        Image.asset(
                                          appLogo,
                                          fit: BoxFit.cover,
                                          height: 30,
                                          width: 30,
                                        ),
                                        horizontalSmallSpace,
                                        Expanded(
                                          child: Text(
                                            LocaleKeys.homeTxtTestLibrary
                                                .tr(),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: darkColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                verticalMicroSpace,
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: mainLightColor, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.grey.withOpacity(0.15),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      color: whiteColor,
                                    ),
                                    child: Row(
                                      children: [
                                        horizontalMiniSpace,
                                        Image.asset(
                                          appLogo,
                                          fit: BoxFit.cover,
                                          height: 30,
                                          width: 30,
                                        ),
                                        horizontalSmallSpace,
                                        Expanded(
                                          child: Text(
                                            LocaleKeys.homeTxtOffers.tr(),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: darkColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                verticalMicroSpace,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // create widgets for each tab bar here
                  Expanded(
                    child: TabBarView(
                      children: [
                        // first tab bar view widget
                        Column(
                          children: [
                            verticalSmallSpace,
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: ConditionalBuilder(
                                  condition:
                                      state is! AppGetCategoriesLoadingState,
                                  builder: (context) => GridView.count(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20.0,
                                    crossAxisSpacing: 20.0,
                                    childAspectRatio: 1 / 1,
                                    children: List.generate(
                                      AppCubit.get(context)
                                              .categoriesModel
                                              ?.data
                                              ?.length ??
                                          0,
                                      (index) => InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            FadeRoute(
                                              page: TestItemsScreen(
                                                  categoryId:
                                                      AppCubit.get(context)
                                                          .categoriesModel!
                                                          .data![index]
                                                          .id),
                                            ),
                                          );
                                        },
                                        child: CategoriesCard(
                                          categoriesDataModel:
                                              AppCubit.get(context)
                                                  .categoriesModel!
                                                  .data![index],
                                        ),
                                      ),
                                    ),
                                  ),
                                  fallback: (context) => const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // second tab bar view widget
                        Column(
                          children: [
                            verticalSmallSpace,
                            ConditionalBuilder(
                              condition:
                                  state is! AppGetOffersLoadingState,
                              builder: (context) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          FadeRoute(
                                            page: TestDetailsScreen(offersDataModel: AppCubit.get(context).offersModel!.data![index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: OffersCard(
                                        offersDataModel: AppCubit.get(context).offersModel!.data![index],
                                      ),
                                    ),
                                    separatorBuilder: (context, index) =>
                                    horizontalMiniSpace,
                                    itemCount: AppCubit.get(context).offersModel!.data!.length,
                                  ),
                                ),
                              ),
                              fallback: (context) => const Center(child: CircularProgressIndicator.adaptive()),
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
        });
  }
}
