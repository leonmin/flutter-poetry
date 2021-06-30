import 'dart:io';

import 'package:flutter/material.dart';

// Colors
const bg = Color(0xFFF2F2F2);
const kSidebarBackgroundColor = Color(0xFFF1F4FB);
const kCardPopupBackgroundColor = Color(0xFFF5F8FF);
const kShadowColor = Color.fromRGBO(72, 76, 82, 0.16);

const kPrimaryLabelColor = Color(0xFF242629);
const kSecondaryLabelColor = Color(0xFF797F8A);
const kCourseElementIconColor = Color(0xFF17294D);
const kBlack = Color(0xff262626);
// const kTang = Color(0xffd10f0e);
const kTang = Colors.red;
// const kSong = Color(0xff9c7737);
// const kSong = Color(0xffF24646);
// const kSong = Color(0xff10B10C);
const kSong = Colors.yellow;

const kActive = Color(0xffed4956);

var kAuthor = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

var kRhythmic = TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.bold, color: kBlack, height: 2);

var kParagraphs = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);
var kUsername = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
var kLabelBold = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

var kLabel = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);
var kList = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);
// Text Styles
var kLargeTitleStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kTitle1Style = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kCardTitleStyle = TextStyle(
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontSize: 22.0,
  decoration: TextDecoration.none,
);
var kTitle2Style = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kHeadlineLabelStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w800,
  color: kPrimaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
var kSubtitleStyle = TextStyle(
  fontSize: 16.0,
  color: kSecondaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kBodyLabelStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kCalloutLabelStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w800,
  color: kPrimaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kSecondaryCalloutLabelStyle = TextStyle(
  fontSize: 16.0,
  color: kSecondaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kSearchPlaceholderStyle = TextStyle(
  fontSize: 13.0,
  color: kSecondaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kSearchTextStyle = TextStyle(
  fontSize: 13.0,
  color: kPrimaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
var kCardSubtitleStyle = TextStyle(
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  color: Color(0xE6FFFFFF),
  fontSize: 13.0,
  decoration: TextDecoration.none,
);
var kCaptionLabelStyle = TextStyle(
  fontSize: 12.0,
  color: kSecondaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  decoration: TextDecoration.none,
);
