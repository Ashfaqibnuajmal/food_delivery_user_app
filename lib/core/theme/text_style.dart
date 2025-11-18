import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';

// Onboarding & General Buttons
const TextStyle orangeTextStyle = TextStyle(
  color: AppColors.primaryOrange,
  fontSize: 16,
);

const TextStyle orangeBoldTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: AppColors.primaryOrange,
);
const TextStyle orangeBoldSmallTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: AppColors.primaryOrange,
);

// Onboarding Page
const TextStyle blackBoldTextStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle lightBlackTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black54,
);

// Sign Up / Login Page
const TextStyle blackBoldBigTextStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle greyTextStyle = TextStyle(fontSize: 16, color: Colors.grey);
const TextStyle greySmallTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey,
);

// Base Text Style for Questions, Links, Buttons, etc.
const TextStyle anyColorTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const TextStyle anyColorTextStyleSmall = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
const TextStyle smallBold = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
);
const TextStyle mediumBold = TextStyle(
  fontSize: 16,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const TextStyle bigBold = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

const TextStyle appbarText = TextStyle(
  color: AppColors.black,
  letterSpacing: 0.3,
  fontStyle: FontStyle.italic,
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

const TextStyle emptyTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 16,
  fontStyle: FontStyle.italic,
);

const TextStyle prepkcalTextStyle = TextStyle(color: Colors.grey, fontSize: 12);

const TextStyle ratingTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 12,
);

const TextStyle homePageTitles = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.5,
  shadows: [Shadow(offset: Offset(0, 1.5), blurRadius: 4, color: Colors.grey)],
);
const TextStyle offer = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.8,
);
const TextStyle viewTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.underline,
  decorationColor: Colors.grey,
  decorationThickness: 1.5,
  shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black)],
);

TextStyle priceStyle({required bool isTodayOffer}) {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: isTodayOffer ? Colors.redAccent : Colors.black,
  );
}
