// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  geolocator.Position? position;

  MapScreen({
    Key? key,
    this.position,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var formKey = GlobalKey<FormState>();
  final focusNodes = Iterable<int>.generate(4).map((_) => FocusNode()).toList();
  GoogleMapController? topController;
  double mLatitude = 0;
  double mLongitude = 0;
  late bool isInit;

  geolocator.Position? position;

  Future<void> getLocation() async {
    position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high);
  }

  @override
  void initState() {
    if (Platform.isIOS) {
      getLocation().then((v) {
        setState(() {
          getAddressBasedOnLocation(
              lat: position?.latitude, long: position?.longitude);
          mLatitude = position!.latitude;
          mLongitude = position!.longitude;
        });
      });
    } else {
      mLatitude = widget.position!.latitude;
      mLongitude = widget.position!.longitude;
      getAddressBasedOnLocation(lat: mLatitude, long: mLongitude);
    }

    super.initState();
  }

  Location currentLocation = Location();
  final Set<Marker> markers = {};
  geo.Placemark? userAddress;
  String? addressLocation;
  Location location = Location();

  final addressController = TextEditingController();
  final markOfPlaceController = TextEditingController();
  final floorController = TextEditingController();
  final buildingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreateAddressSuccessState) {
          if (state.successModel.status) {
            Navigator.pop(context);
            showToast(
                msg: state.successModel.message, state: ToastState.success);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Icon(
              Icons.gps_fixed_outlined,
              color: mainColor,
            ),
            elevation: 0.0,
            backgroundColor: whiteColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: greyDarkColor,
              ),
              onPressed: () {
                currentLocation.serviceEnabled().ignore();
                Navigator.pop(context);
              },
            ),
          ),
          // appBar: GeneralAppBar(title: '',),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  zoomControlsEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(mLatitude, mLongitude),
                    zoom: 17.0,
                  ),
                  onTap: (value){
                    getAddressBasedOnLocation(lat: value.latitude,long: value.longitude);
                  },
                  markers: markers,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: KeyboardActions(
                      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
                      config: KeyboardActionsConfig(
                        // Define ``defaultDoneWidget`` only once in the config
                        defaultDoneWidget: doneKeyboard(),
                        actions: focusNodes
                            .map((focusNode) =>
                                KeyboardActionsItem(focusNode: focusNode))
                            .toList(),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Form(
                            key: formKey,
                            child: DefaultFormField(
                              controller: addressController,
                              focusNode: focusNodes[0],
                              suffixIcon: Icons.location_searching,
                              type: TextInputType.text,
                              validatedText: LocaleKeys.txtFieldAddress.tr(),
                              label: LocaleKeys.txtFieldAddress.tr(),
                              onTap: () {},
                              suffixPressed: () {
                                addressController.text = addressLocation ?? '';
                              },
                            ),
                          ),
                          verticalSmallSpace,
                          DefaultFormField(
                            controller: markOfPlaceController,
                            focusNode: focusNodes[1],
                            type: TextInputType.text,
                            label: LocaleKeys.txtMarkOfThePlace.tr(),
                            onTap: () {},
                          ),
                          verticalSmallSpace,
                          DefaultFormField(
                            controller: floorController,
                            focusNode: focusNodes[2],
                            type: TextInputType.number,
                            label: LocaleKeys.txtFloorNumber.tr(),
                            onTap: () {},
                          ),
                          verticalSmallSpace,
                          DefaultFormField(
                            controller: buildingController,
                            focusNode: focusNodes[3],
                            type: TextInputType.number,
                            label: LocaleKeys.txtBuildingNumber.tr(),
                            onTap: () {},
                          ),
                          verticalSmallSpace,
                          ConditionalBuilder(
                            condition: state is! AppCreateAddressLoadingState,
                            builder: (context) => GeneralButton(
                              title: LocaleKeys.txtFieldAddress.tr(),
                              onPress: () {
                                if (formKey.currentState!.validate()) {
                                  AppCubit.get(context).createAddress(
                                    latitude: mLongitude,
                                    longitude: mLongitude,
                                    address: addressController.text,
                                  );
                                }
                              },
                            ),
                            fallback: (context) => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                          verticalLargeSpace
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future _getLocation({double? lat, double? long}) async {
    LocationData pos = await location.getLocation();
    mLatitude = pos.latitude!;
    mLongitude = pos.longitude!;
    lat = mLatitude;
    long = mLongitude;
    if (kDebugMode) {
      print('latitude inside get location $lat');
    }
    var permission = await currentLocation.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await currentLocation.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    } else {
      currentLocation.onLocationChanged.listen((LocationData loc) {
        lat = loc.latitude!;
        long = loc.longitude!;
        topController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(loc.latitude!, loc.longitude!),
              zoom: 17.0,
            ),
          ),
        );
        markers.add(
          Marker(
              markerId: const MarkerId('Home'),
              position: LatLng(loc.latitude ?? lat ?? mLatitude,
                  loc.longitude ?? long ?? mLongitude)),
        );
      });
      mLatitude = lat!;
      mLongitude = long!;
    }
  }

  Future<void> getAddressBasedOnLocation({double? lat, double? long}) async {
    await _getLocation(lat: lat, long: long).then((value) async {
      var address = await geo.placemarkFromCoordinates(lat!, long!);
      userAddress = address.first;
      if (kDebugMode) {
        print('from getAddressBasedOnLocation userAddress : $userAddress');
      }
      topController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 14.0,
          ),
        ),
      );
      markers.add(
        Marker(markerId: const MarkerId('Home'), position: LatLng(lat, long)),
      );

      addressLocation =
          '${userAddress?.administrativeArea} ${userAddress?.locality} ${userAddress?.street} ${userAddress?.subThoroughfare}';
    });
    setState(() {
      addressController.text = addressLocation ?? '';
      markOfPlaceController.text = userAddress?.thoroughfare ?? '';
      buildingController.text = userAddress?.subThoroughfare ?? '';
    });
  }
}
