
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';

final kToday = DateTime.now();

var day;
var month;

final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 5, kToday.day);

var titleStyle = TextStyle(color: darkColor,fontFamily: fontFamily,fontSize: 20,fontWeight: FontWeight.bold);

var titleSmallStyle = TextStyle(color: darkColor,fontFamily: fontFamily,fontSize: 16,fontWeight: FontWeight.w600);

var titleSmallStyle2 = TextStyle(color: darkColor,fontFamily: fontFamily,fontSize: 12,fontWeight: FontWeight.w600);

var titleSmallStyleGreen = TextStyle(color: greenColor,fontFamily: fontFamily,fontSize: 14,fontWeight: FontWeight.w600);

var titleSmallStyleRed = TextStyle(color: redColor,fontFamily: fontFamily,fontSize: 14,fontWeight: FontWeight.w600);

var subTitleSmallStyle = TextStyle(color: greyDarkColor,fontFamily: fontFamily,fontSize: 14,fontWeight: FontWeight.normal);

var subTitleSmallStyle2 = TextStyle(color: greyDarkColor,fontFamily: fontFamily,fontSize: 12,fontWeight: FontWeight.w600);

var subTitleSmallStyle3 = TextStyle(color: greyDarkColor,fontFamily: fontFamily,fontSize: 10,fontWeight: FontWeight.w600);

const verticalMicroSpace = SizedBox(height: 5,);

const verticalMiniSpace = SizedBox(height: 10,);

const verticalSmallSpace = SizedBox(height: 15);

const verticalMediumSpace = SizedBox(height: 25);

const verticalLargeSpace = SizedBox(height: 35);

const horizontalMicroSpace = SizedBox(width: 5,);

const horizontalMiniSpace = SizedBox(width: 10,);

const horizontalSmallSpace = SizedBox(width: 15);

const horizontalMediumSpace = SizedBox(width: 25);

const horizontalLargeSpace = SizedBox(width: 35);

