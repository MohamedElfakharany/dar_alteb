// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable, library_private_types_in_public_api

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/card_screen.dart';
import 'package:dar_elteb/screens/main_screens/notification_screen.dart';
import 'package:dar_elteb/screens/main_screens/search_screen.dart';
import 'package:dar_elteb/shared/components/cached_network_image.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      FadeRoute(page: widget),
      (Route<dynamic> route) => false,
    );

void showToast({
  required String? msg,
  required ToastState? state,
}) {
  Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: chooseToastColor(state!),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastState { success, error, warning }

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.success:
      color = Colors.green;
      break;
    case ToastState.warning:
      color = Colors.amber;
      break;
    case ToastState.error:
      color = Colors.red;
      break;
  }
  return color;
}

Widget myHorizontalDivider() => Padding(
      padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 10),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey.withOpacity(0.5),
      ),
    );

Widget myVerticalDivider() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1.0,
        height: double.infinity,
        color: greyLightColor.withOpacity(0.5),
      ),
    );

class GeneralButton extends StatelessWidget {
  double width;
  double height;
  double radius;
  double offSet;
  Color btnBackgroundColor;
  String title;
  Function onPress;
  double fontSize;
  Color txtColor;

  GeneralButton({
    Key? key,
    this.width = double.infinity,
    this.height = 50,
    this.radius = 8,
    this.offSet = 15,
    this.fontSize = 18,
    this.btnBackgroundColor = mainColor,
    this.txtColor = whiteColor,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: btnBackgroundColor),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle.copyWith(
                color: txtColor,
                fontWeight: FontWeight.normal,
                fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}

class GeneralUnfilledButton extends StatelessWidget {
  final String title;
  final String? image;
  final Color color;
  final Color borderColor;
  final Function onPress;
  final double width;
  final double height;
  final double btnRadius;
  final double borderWidth;
  final double titleSize;

  const GeneralUnfilledButton({
    Key? key,
    required this.title,
    this.color = mainColor,
    this.borderColor = mainColor,
    required this.onPress,
    this.width = 50,
    this.height = 50,
    this.btnRadius = 8,
    this.borderWidth = 2,
    this.image,
    this.titleSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPress();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(btnRadius),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
          color: whiteColor,
        ),
        child: Row(
          children: [
            if (image != null) horizontalSmallSpace,
            if (image != null)
              Image.asset(
                '$image',
                fit: BoxFit.cover,
                height: 30,
                width: 30,
              ),
            if (image != null) horizontalSmallSpace,
            if (image != null)
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: titleSize,
                    color: color,
                  ),
                ),
              ),
            if (image == null)
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GeneralAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  double? leadingWidth;
  bool? centerTitle;
  Color? appBarColor;
  Widget? leading;
  List<Widget>? actions;

  double? appbarPreferredSize;
  Color? appbarBackButtonColor;

  GeneralAppBar(
      {Key? key,
      required this.title,
      this.leadingWidth,
      this.centerTitle = true,
      this.appBarColor = whiteColor,
      this.leading,
      this.actions,
      this.appbarPreferredSize = 60,
      this.appbarBackButtonColor = whiteColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ??
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: greyDarkColor,
            ),
          ),
      centerTitle: centerTitle,
      title: Text(
        title,
        style: titleStyle.copyWith(fontWeight: FontWeight.normal),
      ),
      actions: actions,
      backgroundColor: appBarColor,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(appbarPreferredSize ?? kToolbarHeight);
}

class GeneralHomeLayoutAppBar extends StatelessWidget with PreferredSizeWidget {
  const GeneralHomeLayoutAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppGetCartSuccessState) {
          if (state.cartModel.status == true) {
            if (state.cartModel.data!.isEmpty) {
              showToast(msg: LocaleKeys.noDataToShow.tr(), state: ToastState.error);
            } else {
              Navigator.push(
                context,
                FadeRoute(
                  page: CartScreen(),
                ),
              );
            }
          } else {
            showToast(msg: state.cartModel.message, state: ToastState.error);
          }
        } else if (state is AppGetCartErrorState) {
          showToast(msg: state.error, state: ToastState.error);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        String notifications;
        if (AppCubit.get(context).notificationsModel != null) {
          if (AppCubit.get(context).notificationsModel!.data!.length > 9) {
            notifications = '+9';
          } else {
            notifications = AppCubit.get(context)
                .notificationsModel!
                .data!
                .length
                .toString();
          }
        } else {
          notifications = '';
        }
        String cart;
        if (AppCubit.get(context).cartModel != null) {
          if (AppCubit.get(context).cartModel!.data!.length > 9) {
            cart = '+9';
          } else {
            cart = AppCubit.get(context).cartModel!.data!.length.toString();
          }
        } else {
          cart = '';
        }
        return AppBar(
          backgroundColor: greyExtraLightColor,
          elevation: 0.0,
          title: Row(
            children: [
              if (AppCubit.get(context).isVisitor == true)
                CircleAvatar(
                  backgroundColor: whiteColor,
                  radius: 15,
                  child: CachedNetworkImageCircular(
                      imageUrl: cubit.userResourceModel?.data?.profile ?? ''),
                ),
              if (AppCubit.get(context).isVisitor == false)
                CircleAvatar(
                  backgroundColor: whiteColor,
                  radius: 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CachedNetworkImage(
                      imageUrl: AppCubit.get(context)
                              .userResourceModel
                              ?.data
                              ?.profile ??
                          '',
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
                ),
              horizontalMiniSpace,
              if (AppCubit.get(context).isVisitor == false)
                Expanded(
                  child: Text(
                    '${cubit.userResourceModel?.data?.name ?? ''} ,',
                    textAlign: TextAlign.start,
                    style: titleSmallStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (AppCubit.get(context).isVisitor == true)
                Expanded(
                  child: Text(
                    '${LocaleKeys.homeTxtWelcome.tr()} ,',
                    textAlign: TextAlign.start,
                    style: titleSmallStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  FadeRoute(
                    page: const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
                size: 30,
                color: mainColor,
              ),
            ),
            if (AppCubit.get(context).isVisitor == false)
              ConditionalBuilder(
                condition: state is! AppGetCartLoadingState,
                builder: (context) => InkWell(
                  onTap: () {
                    AppCubit.get(context).getCart();
                  },
                  child: Badge(
                    position: BadgePosition.topEnd(top: 0),
                    alignment: AlignmentDirectional.centerEnd,
                    animationType: BadgeAnimationType.slide,
                    badgeContent: Text(
                      cart,
                      style: titleSmallStyle2.copyWith(color: whiteColor),
                    ),
                    child: const ImageIcon(
                      AssetImage(
                        'assets/images/lab.png',
                      ),
                      color: mainColor,
                    ),
                  ),
                ),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
              ),
            horizontalSmallSpace,
            if (AppCubit.get(context).isVisitor == false)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: const NotificationScreen(),
                    ),
                  );
                },
                child: Badge(
                  position: BadgePosition.topEnd(top: 0),
                  alignment: AlignmentDirectional.centerEnd,
                  animationType: BadgeAnimationType.slide,
                  badgeContent: Text(
                    notifications,
                    style: titleSmallStyle2.copyWith(
                      color: whiteColor,
                    ),
                  ),
                  child: const ImageIcon(
                    AssetImage(
                      'assets/images/notification.png',
                    ),
                    color: mainColor,
                  ),
                ),
              ),
            if (AppCubit.get(context).isVisitor == false) horizontalSmallSpace,
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

class DefaultTextButton extends StatelessWidget {
  String title;
  Widget? screen;
  bool isFinish;
  AlignmentDirectional align;
  FontWeight? weight;

  DefaultTextButton(
      {Key? key,
      required this.title,
      this.weight = FontWeight.w400,
      this.screen,
      this.isFinish = false,
      this.align = AlignmentDirectional.centerEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 20.0),
      child: Align(
        alignment: align,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: mainColor,
            fontFamily: fontFamily,
            fontWeight: weight,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

class DefaultFormField extends StatelessWidget {
  TextEditingController controller;
  TextInputType type;
  Function? onSubmit;
  Function? onChange;
  dynamic validatedText;
  dynamic onTap;
  bool obscureText = false;
  String label;
  Widget? prefixIcon;
  Function? prefixPressed;
  IconData? suffixIcon;
  Color suffixColor;
  Color prefixColor;
  Function? suffixPressed;
  bool isClickable = true;
  bool readOnly = false;
  bool autoFocus = false;
  bool removeBorder;
  double height;
  EdgeInsetsGeometry? contentPadding;
  String? hintText;
  bool expend;
  bool isConfirm = false;
  String? confirm;
  FocusNode? focusNode;

  DefaultFormField({
    Key? key,
    this.focusNode,
    required this.controller,
    required this.type,
    this.expend = false,
    this.onSubmit,
    this.onChange,
    this.validatedText,
    this.onTap,
    this.hintText,
    this.removeBorder = true,
    this.obscureText = false,
    this.prefixColor = mainColor,
    required this.label,
    this.prefixIcon,
    this.prefixPressed,
    this.suffixIcon,
    this.suffixColor = mainColor,
    this.suffixPressed,
    this.isClickable = true,
    this.readOnly = false,
    this.contentPadding,
    this.height = 80,
    this.autoFocus = false,
    this.isConfirm = false,
    this.confirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      alignment: AlignmentDirectional.center,
      child: TextFormField(
        focusNode: focusNode,
        expands: expend,
        validator: (value) {
          if (value!.isEmpty) {
            return '${LocaleKeys.txtFill.tr()} $validatedText';
          }
          if (isConfirm == true) {
            if (value != confirm
                // && validatedText == LocaleKeys.TxtFieldReEnterPassword.tr()
                ) {
              return LocaleKeys.txtPasswordsNotMatch.tr();
            }
          }
          if (validatedText == LocaleKeys.txtFieldMobile.tr()) {
            if (value.length < 9) {
              return LocaleKeys.txtMobileLessNine.tr();
            }
          }
          if (validatedText == LocaleKeys.txtFieldPassword.tr() ||
              validatedText == LocaleKeys.TxtFieldNewPassword.tr() ||
              validatedText == LocaleKeys.TxtFieldReEnterPassword.tr() ||
              validatedText == LocaleKeys.TxtFieldOldPassword.tr()) {
            if (value.length < 8) {
              return LocaleKeys.txtPasswordValidate.tr();
            }
          }
          if (validatedText == LocaleKeys.txtFieldIdNumber.tr()) {
            if (value.length != 10) {
              return LocaleKeys.txtNationalIdValidate.tr();
            }
          }
          if (validatedText == LocaleKeys.txtFieldCodeReset.tr()) {
            if (value.length != 6) {
              return LocaleKeys.txtCheckCodeTrue.tr();
            }
          }

          if (validatedText == LocaleKeys.txtFieldCoupon.tr()) {
            if (value.length != 10) {
              return LocaleKeys.txtCouponValidation.tr();
            }
          }
        },
        autofocus: autoFocus,
        controller: controller,
        keyboardType: type,
        maxLines: obscureText ? 1 : null,
        obscureText: obscureText,
        obscuringCharacter: '*',
        readOnly: readOnly,
        enabled: isClickable,
        onFieldSubmitted: (val) {
          onSubmit;
        },
        onChanged: (val) {
          onChange;
        },
        onTap: () {
          onTap();
        },
        cursorColor: mainColor,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: greyExtraLightColor.withOpacity(0.4),
            ),
          ),
          prefixIcon: prefixIcon != null
              ? IconButton(
                  icon: prefixIcon!,
                  onPressed: () {
                    prefixPressed;
                  },
                )
              : null,
          suffixIcon: IconButton(
            onPressed: () {
              suffixPressed!();
            },
            icon: Icon(suffixIcon),
            color: mainColor,
          ),
          hintStyle: const TextStyle(color: greyDarkColor, fontSize: 14),
          labelStyle: const TextStyle(
            // color: isClickable ? Colors.grey[400] : blueColor,
            color: greyDarkColor,
            fontSize: 14,
          ),
          fillColor: Colors.white,
          filled: true,
          errorStyle: const TextStyle(color: redColor),
          // floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: contentPadding ??
              const EdgeInsetsDirectional.only(
                  start: 15.0, end: 15.0, bottom: 15.0, top: 15.0),
        ),
        style: const TextStyle(
            color: mainLightColor, fontSize: 18, fontFamily: fontFamily),
      ),
    );
  }
}

class GeneralNationalityCode extends StatefulWidget {
  GeneralNationalityCode({
    this.canSelect,
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;
  bool? canSelect = true;

  @override
  State<GeneralNationalityCode> createState() => _GeneralNationalityCodeState();
}

class _GeneralNationalityCodeState extends State<GeneralNationalityCode> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.none,
      readOnly: widget.canSelect != null ? true : false,
      validator: (value) {
        if (value!.isEmpty) {
          return '${LocaleKeys.txtFill.tr()} ${LocaleKeys.txtFieldNationality.tr()}';
        }
      },
      onTap: () {
        if (widget.canSelect == true) {
          showCountryPicker(
            context: context,
            onSelect: (Country country) {
              setState((){
                  widget.controller.text = country.phoneCode;});
            },
          );
        } else {}
      },
      decoration: InputDecoration(
        labelText: LocaleKeys.txtFieldNationality.tr(),
        hintText: LocaleKeys.txtFieldNationality.tr(),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: greyExtraLightColor.withOpacity(0.4),
          ),
        ),
        hintStyle: const TextStyle(color: greyDarkColor, fontSize: 14),
        labelStyle: const TextStyle(
          // color: isClickable ? Colors.grey[400] : blueColor,
          color: greyDarkColor,
          fontSize: 14,
        ),
        fillColor: Colors.white,
        filled: true,
        errorStyle: const TextStyle(color: redColor),
        // floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsetsDirectional.only(
            start: 5.0, end: 0.0, bottom: 0.0, top: 0.0),
      ),
      style: const TextStyle(
          color: mainLightColor, fontSize: 18, fontFamily: fontFamily),
    );
  }
}

Widget textLabel({required String title}) {
  return Text(
    title,
    style: titleSmallStyle.copyWith(fontWeight: FontWeight.normal),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 15),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

// class DownloadImage extends StatefulWidget {
//   const DownloadImage({Key? key, required this.imageUrl}) : super(key: key);
//   final imageUrl;
//   @override
//   State<DownloadImage> createState() => _DownloadImageState();
// }
//
// class _DownloadImageState extends State<DownloadImage> {
//   final Dio dio = Dio();
//   bool loading = false;
//   double progress = 0;
//
//   Future<bool> saveVideo(String url, String fileName) async {
//     Directory? directory;
//     try {
//       if (Platform.isAndroid) {
//         if (await _requestPermission(Permission.storage)) {
//           directory = await getExternalStorageDirectory();
//           String newPath = "";
//           if (kDebugMode) {
//             print(directory);
//           }
//           List<String> paths = directory!.path.split("/");
//           for (int x = 1; x < paths.length; x++) {
//             String folder = paths[x];
//             if (folder != "Android") {
//               newPath += "/" + folder;
//             } else {
//               break;
//             }
//           }
//           newPath = newPath + "/DarAltepApp";
//           directory = Directory(newPath);
//         } else {
//           return false;
//         }
//       } else {
//         if (await _requestPermission(Permission.photos)) {
//           directory = await getTemporaryDirectory();
//         } else {
//           return false;
//         }
//       }
//       File saveFile = File(directory.path + "/$fileName");
//       if (!await directory.exists()) {
//         await directory.create(recursive: true);
//       }
//       if (await directory.exists()) {
//         await dio.download(url, saveFile.path,
//             onReceiveProgress: (value1, value2) {
//               setState(() {
//                 progress = value1 / value2;
//               });
//             });
//         if (Platform.isIOS) {
//           await GallerySaver.saveFile(saveFile.path);
//         }
//         return true;
//       }
//       return false;
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       return false;
//     }
//   }
//
//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   downloadFile() async {
//     setState(() {
//       loading = true;
//       progress = 0;
//     });
//     bool downloaded = await saveVideo(
//         widget.imageUrl,
//         "DarAltep.jpeg");
//
//     if (downloaded) {
//       if (kDebugMode) {
//         print("File Downloaded");
//       }
//     } else {
//       if (kDebugMode) {
//         print("Problem Downloading File");
//       }
//     }
//     setState(() {
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: loading
//           ? Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: LinearProgressIndicator(
//           minHeight: 10,
//           value: progress,
//         ),
//       ):GeneralButton(
//         title: 'Download',
//         radius: 8,
//         btnBackgroundColor: blueLight,
//         onPress: downloadFile,
//       ),
//     );
//   }
// }

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: mainColor),
  );
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({
    required this.page,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

void showPopUp(BuildContext context, Widget widget) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: widget,
      contentPadding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    ),
  );
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) {
    if (kDebugMode) {
      print(match.group(0));
    }
  });
}

class ScreenHolder extends StatelessWidget {
  final String msg;

  const ScreenHolder({required this.msg, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${LocaleKeys.txtThereIsNo.tr()} $msg ${LocaleKeys.txtYet.tr()}',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: mainColor),
      ),
    );
  }
}

void showCustomBottomSheet(
  BuildContext context, {
  required Widget bottomSheetContent,
  required double bottomSheetHeight,
}) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return ScreenUtilInit(
          builder: (ctx, _) {
            return SizedBox(
              height: bottomSheetHeight.sh,
              child: bottomSheetContent,
            );
          },
        );
      });
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({Key? key,
    this.height = 1,
    this.color = greyLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 5.0;
          final dashHeight = height;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

Widget doneKeyboard() {
  return const Text(
    'done',
    style: titleSmallStyle,
  );
}
