// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';

class TestItemsScreen extends StatefulWidget {
  const TestItemsScreen({Key? key, required this.categoryId}) : super(key: key);
  final categoryId;

  @override
  State<TestItemsScreen> createState() => _TestItemsScreenState();
}

class _TestItemsScreenState extends State<TestItemsScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 0),
      () {
        // AppCubit.get(context).getTests(categoriesId: widget.categoryId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getTests(categoriesId: widget.categoryId),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: GeneralAppBar(
              title: AppCubit.get(context)
                      .categoriesModel
                      ?.data?[widget.categoryId - 1]
                      .title ??
                  '',
              centerTitle: false,
              // actions: [
              //   IconButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         FadeRoute(
              //           page: const SearchScreen(),
              //         ),
              //       );
              //     },
              //     icon: const Icon(
              //       Icons.search,
              //       size: 30,
              //       color: blueColor,
              //     ),
              //   ),
              //   horizontalMiniSpace
              // ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ConditionalBuilder(
                condition: state is! AppGetTestsLoadingState,
                builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => TestItemCard(index: index),
                  separatorBuilder: (context, index) => verticalMiniSpace,
                  itemCount: AppCubit.get(context).testsModel?.data?.length ?? 0,
                ),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
              ),
            ),
          );
        },
      ),
    );
  }
}
