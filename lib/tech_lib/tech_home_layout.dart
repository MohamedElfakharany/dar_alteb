import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class TechHomeLayoutScreen extends StatelessWidget {
  const TechHomeLayoutScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cubit = AppTechCubit.get(context);
    isEnglishShared = CacheHelper.getData(key: 'isEnglish');
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              cubit.changeBottomScreen(index);
            },
            showUnselectedLabels: true,
            selectedItemColor: mainColor,
            unselectedItemColor: greyLightColor,
            currentIndex: cubit.currentIndex,
            unselectedLabelStyle: subTitleSmallStyle2,
            selectedLabelStyle: titleSmallStyle2.copyWith(color: mainColor),
            items: [
              BottomNavigationBarItem(
                icon: const ImageIcon(AssetImage('assets/images/homeUnselected.png'),),
                label: LocaleKeys.TxtHomeVisit.tr(),
                activeIcon: const ImageIcon(AssetImage('assets/images/homeSelected.png'),),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(AssetImage('assets/images/requestsUnSelected.png'),),
                label: LocaleKeys.txtRequests.tr(),
                activeIcon: const ImageIcon(AssetImage('assets/images/requestsSelected.png'),),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(AssetImage('assets/images/reservedUnSelected.png'),),
                label: LocaleKeys.txtReserved.tr(),
                activeIcon: const ImageIcon(AssetImage('assets/images/reservedSelected.png'),),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(AssetImage('assets/images/profileUnSelected.png'),),
                label: LocaleKeys.drawerSettings.tr(),
                activeIcon: const ImageIcon(AssetImage('assets/images/profileSelected.png'),),
              ),
            ],
          ),
        );
      },
    );
  }
}