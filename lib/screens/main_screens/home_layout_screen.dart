import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    isEnglishShared = CacheHelper.getData(key: 'isEnglish');
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: const GeneralHomeLayoutAppBar(),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              cubit.changeBottomScreen(index);
            },
            showUnselectedLabels: true,
            selectedItemColor: mainColor,
            unselectedItemColor: greyLightColor,
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: const ImageIcon(AssetImage('assets/images/homeUnselected.png'),),
                label: LocaleKeys.TxtHomeVisit.tr(),
                activeIcon: const ImageIcon(AssetImage('assets/images/homeSelected.png'),),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(AssetImage('assets/images/tests.png'),),
                label: LocaleKeys.homeTxtTestLibrary.tr(),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(AssetImage('assets/images/reservedUnSelected.png'),),
                label: LocaleKeys.txtReserved.tr(),
                activeIcon: const ImageIcon(AssetImage('assets/images/reservedSelected.png'),),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(AssetImage('assets/images/requestsUnSelected.png'),),
                label: LocaleKeys.BtnResult.tr(),
                activeIcon: const ImageIcon(AssetImage('assets/images/requestsSelected.png'),),
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
