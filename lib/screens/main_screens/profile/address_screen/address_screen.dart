import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/profile/address_screen/map_screen.dart';
import 'package:dar_elteb/screens/main_screens/profile/widget_components/widget_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:permission_handler/permission_handler.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late Future<bool> positionDone;

  @override
  void initState() {
    super.initState();
    permission();
    AppCubit.get(context).getAddress();
    positionDone = waiting();
  }

  Position? position;

  /// Invoke the file picker
  Future<void> getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> permission() async {
    PermissionStatus result;
    // In Android we need to request the storage permission,
    // while in iOS is the photos permission
    if (Platform.isAndroid) {
      result = await Permission.location.request();
    } else {
      result = await Permission.locationAlways.request();
    }

    if (result.isGranted) {
      getLocation();
      return true;
    } else if (Platform.isIOS || result.isPermanentlyDenied) {
      return false;
    } else {
      return false;
    }
  }

  Future<bool> waiting() async {
    await Future.delayed(
      const Duration(seconds: 5),
    );
    if (position?.longitude != null ){
      return true;
    }else {
    return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtAddress.tr(),
            appBarColor: greyExtraLightColor,
            centerTitle: false,
          ),
          body: FutureBuilder(
            future: positionDone,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (Platform.isIOS) {
                            Navigator.push(
                              context,
                              FadeRoute(
                                page: MapScreen(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              FadeRoute(
                                page: MapScreen(
                                  position: position,
                                ),
                              ),
                            );
                          }
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
                              LocaleKeys.txtNewAddress.tr(),
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
                          condition: state is! AppGetAddressLoadingState &&
                              state is! AppDeleteAddressLoadingState &&
                              state is! AppSelectAddressLoadingState,
                          builder: (context) => ListView.separated(
                            itemBuilder: (context, index) => SwipeActionCell(
                                key: ValueKey(AppCubit.get(context)
                                    .addressModel!
                                    .data![index]),
                                trailingActions: [
                                  SwipeAction(
                                    nestedAction: SwipeNestedAction(
                                      /// customize your nested action content
                                      content: ConditionalBuilder(
                                        condition: state
                                            is! AppDeleteAddressLoadingState,
                                        builder: (context) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.red,
                                          ),
                                          width: 130,
                                          height: 60,
                                          child: OverflowBox(
                                            maxWidth: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                Text(LocaleKeys.BtnDelete.tr(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        fallback: (context) => const Center(
                                            child: CircularProgressIndicator
                                                .adaptive()),
                                      ),
                                    ),

                                    /// you should set the default  bg color to transparent
                                    color: Colors.transparent,

                                    /// set content instead of title of icon
                                    content: _getIconButton(
                                        Colors.red, Icons.delete),
                                    onTap: (handler) async {
                                      AppCubit.get(context).deleteAddress(
                                        addressId: AppCubit.get(context)
                                            .addressModel!
                                            .data![index]
                                            .id,
                                      );
                                    },
                                  ),
                                ],
                                child: InkWell(
                                  onTap: () {
                                    AppCubit.get(context).selectAddress(
                                        addressId: AppCubit.get(context)
                                            .addressModel!
                                            .data![index]
                                            .id);
                                  },
                                  child: AddressCard(
                                    addressDataModel: AppCubit.get(context)
                                        .addressModel!
                                        .data![index],
                                    index: index,
                                  ),
                                )),
                            separatorBuilder: (context, index) =>
                                verticalMediumSpace,
                            itemCount: AppCubit.get(context)
                                    .addressModel
                                    ?.data
                                    ?.length ??
                                0,
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
            },
          ),
        );
      },
    );
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        /// set you real bg color in your content
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
