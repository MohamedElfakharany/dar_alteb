import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 0),
          () {
        AppCubit.get(context).getTests();
        // AppCubit.get(context).getTerms();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppAddToCartSuccessState) {
          if (state.successModel.status) {
            showToast(
                msg: state.successModel.message, state: ToastState.success);
          } else {
            showToast(msg: state.successModel.message, state: ToastState.error);
          }
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            appBarColor: greyExtraLightColor,
            title: LocaleKeys.TxtFieldSearch.tr(),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  alignment: AlignmentDirectional.center,
                  height: 60,
                  child: TextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      label: Text(LocaleKeys.TxtFieldSearch.tr()),
                      hintStyle:
                      TextStyle(color: greyDarkColor, fontSize: 14),
                      labelStyle: TextStyle(
                        // color: isClickable ? Colors.grey[400] : blueColor,
                          color: greyDarkColor,
                          fontSize: 14),
                      fillColor: Colors.white,
                      filled: true,
                      errorStyle: TextStyle(color: redColor),
                      contentPadding: const EdgeInsetsDirectional.only(
                          start: 20.0, end: 10.0, bottom: 0.0, top: 0.0),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: greyExtraLightColor,
                        ),
                      ),
                    ),
                    onChanged: (String v){
                      print(v);
                      AppCubit.get(context).getTests(search: v);
                    },
                    style: TextStyle(
                      color: mainLightColor,
                      fontSize: 18,
                      fontFamily: fontFamily,
                    ),
                    maxLines: 1,
                  ),
                ),
                verticalSmallSpace,
                Expanded(
                  child: ConditionalBuilder(
                    condition: state is! AppGetTestsLoadingState,
                    builder: (context) => ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => TestItemCard(index: index),
                      separatorBuilder: (context, index) => verticalMiniSpace,
                      itemCount: cubit.testsModel?.data?.length ?? 0,
                    ),
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
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
