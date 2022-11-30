// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_states.dart';

class TechMapScreen extends StatefulWidget {
  TechMapScreen({Key? key, this.lat, this.long}) : super(key: key);
  dynamic lat;
  dynamic long;

  @override
  State<TechMapScreen> createState() => _TechMapScreenState();
}

class _TechMapScreenState extends State<TechMapScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final Set<Marker> markers = {
          Marker(
            markerId: const MarkerId('Home'),
            position: LatLng(
              double.parse(widget.lat),
              double.parse(widget.long),
            ),
          ),
        };
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
                Navigator.pop(context);
              },
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              zoomControlsEnabled: true,
              mapType: MapType.satellite,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(widget.lat),
                  double.parse(widget.long),
                ),
                zoom: 18.0,
              ),
              markers: markers,
            ),
          ),
        );
      },
    );
  }
}
