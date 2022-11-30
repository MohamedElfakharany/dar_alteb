import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/intro_screens/startup/onboarding_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';

class VisitorHolderScreen extends StatefulWidget {
  const VisitorHolderScreen({Key? key}) : super(key: key);

  @override
  State<VisitorHolderScreen> createState() => VisitorHolderScreenState();
}

class VisitorHolderScreenState extends State<VisitorHolderScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          body: Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, right: 20.0, left: 20.0),
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
                const Text('Please Sign in First 😅 ',style: titleStyle,),
                verticalLargeSpace,
                GeneralButton(title: 'Sign In', onPress: (){
                  AppCubit.get(context).currentIndex = 0;
                  Navigator.pushAndRemoveUntil(context, FadeRoute(page: OnBoardingScreen(),), (route) => false);
                }),
                verticalLargeSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}
