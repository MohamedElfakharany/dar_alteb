import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/screens/main_screens/notification_screen.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';
import 'package:dar_elteb/tech_lib/tech_home_layout.dart';
import 'package:dar_elteb/tech_lib/tech_screens/profile_screens/edit_tech_profile_screen.dart';
import 'package:dar_elteb/tech_lib/tech_screens/profile_screens/tecg_change_password.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class TechProfileScreen extends StatefulWidget {
  const TechProfileScreen({Key? key}) : super(key: key);

  @override
  State<TechProfileScreen> createState() => _TechProfileScreenState();
}

class _TechProfileScreenState extends State<TechProfileScreen> {
  @override
  void initState() {
    super.initState();
    AppTechCubit.get(context).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          body: ConditionalBuilder(
            condition: state is! AppTechGetProfileLoadingState,
            builder: (context) => Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(profileBG),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 20.0,left: 20.0, bottom: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: const NotificationScreen(),
                                  ),
                                );
                              },
                              icon: const ImageIcon(
                                AssetImage('assets/images/notification.png'),
                                color: whiteColor,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(70.0),
                          child: CachedNetworkImage(
                            imageUrl: AppTechCubit.get(context)
                                    .userResourceModel
                                    ?.data
                                    ?.profile ??
                                imageTest,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: mainColor,
                              )),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: whiteColor),
                              child: const Icon(
                                Icons.perm_identity,
                                size: 100,
                                color: mainColor,
                              ),
                            ),
                            width: 120,
                            height: 120,
                          ),
                        ),
                        horizontalSmallSpace,
                        Text(
                          AppTechCubit.get(context)
                                  .userResourceModel
                                  ?.data
                                  ?.name ??
                              '',
                          style: titleStyle.copyWith(color: whiteColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        verticalMiniSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: whiteColor,
                            ),
                            horizontalMiniSpace,
                            Text(
                              '${LocaleKeys.txtBranch.tr()} : ',
                              style: titleSmallStyle.copyWith(color: whiteColor,),
                            ),
                            Text(
                              AppTechCubit.get(context)
                                      .userResourceModel
                                      ?.data
                                      ?.branch?.title ??
                                  '',
                              style:
                                  titleSmallStyle.copyWith(color: whiteColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                verticalMediumSpace,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0, left: 20.0, bottom: 20.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          verticalSmallSpace,
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: const EditTechProfileScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/edit.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.txtEditProfile.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: const TechChangePasswordScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/passwordIcon.png',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.BtnChangePassword.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              setState(
                                    () async {
                                  AppTechCubit.get(context).changeLanguage();
                                  await context
                                      .setLocale(Locale(AppTechCubit.get(context).local!))
                                      .then(
                                        (value) => {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          FadeRoute(
                                              page: const TechHomeLayoutScreen()),
                                              (route) => false)
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/langIcon.png',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.language.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              showPopUp(
                                context,
                                Container(
                                  height: 320,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      verticalSmallSpace,
                                      Image.asset(
                                        'assets/images/warning-2.jpg',
                                        width: 50,
                                        height: 50,
                                      ),
                                      verticalMediumSpace,
                                      Text(
                                        LocaleKeys.drawerLogOutMain.tr(),
                                        textAlign: TextAlign.center,
                                        style: titleStyle.copyWith(
                                          color: redColor,
                                        ),
                                      ),
                                      verticalMediumSpace,
                                      GeneralButton(
                                        radius: radius,
                                        btnBackgroundColor: redColor,
                                        title: LocaleKeys.drawerLogout.tr(),
                                        onPress: () {
                                          AppTechCubit.get(context).currentIndex =
                                              0;
                                          AppTechCubit.get(context)
                                              .signOut(context);
                                        },
                                      ),
                                      verticalSmallSpace,
                                      GeneralButton(
                                        radius: radius,
                                        btnBackgroundColor: greyExtraLightColor,
                                        txtColor: greyDarkColor,
                                        title: LocaleKeys.BtnCancel.tr(),
                                        onPress: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/signOut.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.drawerLogout.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
      },
    );
  }
}
