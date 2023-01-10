import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/home_layout_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class ThankRatingScreen extends StatefulWidget {
  const ThankRatingScreen({Key? key}) : super(key: key);

  @override
  State<ThankRatingScreen> createState() => _ThankRatingScreenState();
}

class _ThankRatingScreenState extends State<ThankRatingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/success.jpg',
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.6,
              // color: blueColor,
            ),
            Text(
              LocaleKeys.txtThankYouForRating.tr(),
              style: titleSmallStyle.copyWith(
                color: greyDarkColor,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSmallSpace,
            MaterialButton(
              onPressed: () {
                AppCubit.get(context).currentIndex = 0;
                Navigator.pushAndRemoveUntil(context, FadeRoute(page: const HomeLayoutScreen(),), (route) => false);
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.txtBackToHome.tr(),
                    style: titleStyle.copyWith(
                        fontSize: 18.0,
                        color: whiteColor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
