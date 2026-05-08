import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';

/// ======================================================
/// ORANGE TEXT STYLES
/// ======================================================

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

/// ======================================================
/// WHITE TEXT STYLES
/// ======================================================

const TextStyle whiteBoldTextStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle whiteBoldSmallTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle whiteVerySmall = TextStyle(
  fontSize: 11,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

/// ======================================================
/// BLACK TEXT STYLES
/// ======================================================

const TextStyle blackBoldTextStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle blackBoldBigTextStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle smallBold = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle mediumBold = TextStyle(
  fontSize: 16,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const TextStyle bigBold = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

/// ======================================================
/// GREY TEXT STYLES
/// ======================================================

const TextStyle greyTextStyle = TextStyle(fontSize: 16, color: Colors.grey);

const TextStyle greySmallTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey,
);

const TextStyle lightBlackTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black54,
);

// ignore: non_constant_identifier_names
TextStyle DateAndTime = TextStyle(
  fontSize: 12,
  color: Colors.grey,
  fontWeight: FontWeight.bold,
);

/// ======================================================
/// RED TEXT STYLES
/// ======================================================

const TextStyle redBold = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

/// ======================================================
/// COMMON / REUSABLE TEXT STYLES
/// ======================================================

const TextStyle anyColorTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const TextStyle anyColorTextStyleSmall = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

/// ======================================================
/// APPBAR TEXT STYLE
/// ======================================================

const TextStyle appbarText = TextStyle(
  color: AppColors.black,
  letterSpacing: 0.3,
  fontStyle: FontStyle.italic,
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

/// ======================================================
/// EMPTY / PLACEHOLDER TEXT STYLE
/// ======================================================

const TextStyle emptyTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 16,
  fontStyle: FontStyle.italic,
);

/// ======================================================
/// FOOD / RATING TEXT STYLES
/// ======================================================

const TextStyle prepkcalTextStyle = TextStyle(color: Colors.grey, fontSize: 12);

const TextStyle ratingTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 12,
);

/// ======================================================
/// HOME PAGE TEXT STYLES
/// ======================================================

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

/// ======================================================
/// ONBOARDING TEXT STYLES
/// ======================================================

const TextStyle joinTextStyle = TextStyle(
  fontWeight: FontWeight.w800,
  fontSize: 15,
  color: Colors.white,
  letterSpacing: 0.2,
  height: 1.3,
);

/// ======================================================
/// DYNAMIC TEXT STYLES
/// ======================================================

TextStyle priceStyle({required bool isTodayOffer}) {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: isTodayOffer ? Colors.redAccent : Colors.black,
  );
}

TextStyle selectableText({required bool isSelected}) {
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: isSelected ? AppColors.primaryOrange : Colors.black87,
  );
}

const TextStyle greenTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Colors.green,
);
