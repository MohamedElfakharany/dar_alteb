import 'package:flutter/material.dart';

const darkColor = Color(0xFF1F1F1F);

const greyDarkColor = Color(0XFF6A6E83);

const greyLightColor = Color(0XFFA8B1CE);

const greyExtraLightColor = Color(0xFFF2F5FF);

const greenColor = Color(0xFF5FBD5D);

const redColor = Color(0xFFBD3430);

const pinkColor = Color(0xFFE397CC);

const yellowColor = Color(0xFFF6C358);

const pendingColor = Color(0xFFFFC700);
const acceptedColor = Color(0xFF009EF7);
const samplingColor = Color(0xFF7239EA);
const finishedColor = Color(0xFF50CD89);
const canceledColor = Color(0xFFF1416C);

/// blue HQ
const mainColor = Color(0xFF2685C7);
const mainLightColor = Color(0xFF4099D3);

/// res sultan
// const mainColor = Color(0xFFDD4E4A);
// const mainLightColor = Color(0xFFEDABAC);

const ofWhiteColor = Color(0xFFF8F9FD);

const whiteColor = Color(0xFFFFFFFF);

var blueGreenGradient = const LinearGradient(
  colors: [Color(0xFF0099CC),Color(0xFF99FF66)],
  tileMode: TileMode.clamp,
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.0,0.0],
);

var transparentGradient = const LinearGradient(
  colors: [Color(0xFF000000),Color(0xFF000000)],
  tileMode: TileMode.clamp,
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.0,1.0],
);