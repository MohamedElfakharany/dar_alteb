import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/profile/family/new_member.dart';
import 'package:dar_elteb/screens/main_screens/profile/widget_components/widget_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({Key? key}) : super(key: key);

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(microseconds: 0),
      () async {
        await AppCubit.get(context).getFamilies();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtFamily.tr(),
            appBarColor: greyExtraLightColor,
            centerTitle: false,
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetFamiliesLoadingState,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        FadeRoute(
                          page: const NewMemberScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      child: Center(
                        child: Text(
                          LocaleKeys.txtNewMember.tr(),
                          style: titleSmallStyle.copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  verticalMediumSpace,
                  Expanded(
                    child: ConditionalBuilder(
                      condition: AppCubit.get(context).familiesModel != null,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) => FamiliesMemberCard(
                            familiesDataModel: AppCubit.get(context)
                                .familiesModel!
                                .data![index]),
                        separatorBuilder: (context, index) =>
                            verticalMediumSpace,
                        itemCount:
                            AppCubit.get(context).familiesModel?.data?.length ??
                                0,
                      ),
                      fallback: (context) =>
                          ScreenHolder(msg: LocaleKeys.txtFamily.tr()),
                    ),
                  ),
                ],
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
      },
    );
  }
}
