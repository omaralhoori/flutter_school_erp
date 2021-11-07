import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/config/frappe_palette.dart';

// Color palette for the unthemed pages
class Palette {

  static Color mColor = Color(0xFF034C8C);
  static Color pColor = Color(0xFFCCFFEB);

  static Color fontColorPrimary = Color(0xFF404040);
  static Color interactionIconsColor = Color(0xFF595959);
  static Color indicatorColor = Color(0xFF04BEC4);
  static Color appBarIconsColor = Color(0xFF03658C);
  static Color homeAppBarColor = Color(0xFFFFFFFF);

  static ThemeData customTheme = ThemeData(
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: fontColorPrimary,
      ),
      bodyText2: TextStyle(
        color: homeAppBarColor,
      ),
      caption: TextStyle(
        color: interactionIconsColor.withOpacity(0.5),
        fontSize: 13,
      ),
    ),
    disabledColor: Colors.black,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black54),
    appBarTheme: AppBarTheme(
      backgroundColor: appBarIconsColor,
      foregroundColor: homeAppBarColor,
    ),
    scaffoldBackgroundColor: homeAppBarColor,

  );


  static Color bgColor = FrappePalette.grey[50]!;
  static Color fieldBgColor = FrappePalette.grey[100]!;
  static Color iconColor = FrappePalette.grey[700]!;
  static Color primaryButtonColor = FrappePalette.blue;
  static Color secondaryButtonColor = FrappePalette.grey[200]!;
  static Color disabledButonColor = FrappePalette.grey;
  static const Color iconColor2 = Color(0xFF1F272E);

  static Color dangerTxtColor = FrappePalette.red[600]!;
  static Color dangerBgColor = FrappePalette.red[100]!;
  static Color warningTxtColor = FrappePalette.orange[600]!;
  static Color warningBgColor = FrappePalette.orange[100]!;
  static Color completeTxtColor = FrappePalette.blue[600]!;
  static Color completeBgColor = FrappePalette.blue[100]!;
  static Color undefinedTxtColor = FrappePalette.grey[600]!;
  static Color undefinedBgColor = FrappePalette.grey[100]!;
  static Color successTxtColor = FrappePalette.darkGreen[600]!;
  static Color successBgColor = FrappePalette.darkGreen[100]!;

  static Color secondaryTxtColor = Color(0xFFB9C0C7);
  static Color newIndicatorColor = Color.fromRGBO(255, 252, 231, 1);

  static EdgeInsets fieldPadding = const EdgeInsets.only(bottom: 24.0);
  static EdgeInsets labelPadding = const EdgeInsets.only(bottom: 4.0);

  // TODO: move

  static TextStyle secondaryTxtStyle = TextStyle(
    color: Palette.secondaryTxtColor,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  static TextStyle altTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    color: Palette.secondaryTxtColor,
  );

  // TODO
  static InputDecoration formFieldDecoration({
    String? label,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool filled = true,
    String? field,
    Color? fillColor,
  }) {
    return InputDecoration(
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      isDense: true,
      contentPadding: field == "check"
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: const BorderRadius.all(
          const Radius.circular(6.0),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: const BorderRadius.all(
          const Radius.circular(6.0),
        ),
      ),
      // hintText: label,
      filled: filled,
      fillColor: fillColor ?? Palette.bgColor,
    );
  }

  static String postingTime(DateTime date, String lang){
    Duration resultDuration = DateTime.now().difference(date);
    DateFormat perfectFormat = DateFormat("yyyy-MM-dd");
    DateFormat monthFormat = DateFormat("MM-dd");

    int inDays = resultDuration.inDays;
    int inHours = resultDuration.inHours;
    int inMinutes = resultDuration.inMinutes;
    int inSeconds = resultDuration.inSeconds;


    if(inDays > 360){
      return "${perfectFormat.format(date)}";
    }
    else if(inDays > 30){
      return "${monthFormat.format(date)}";
    }
    else if(inDays > 7){
      int weeks = (inDays/7).round();
      switch(lang){
        case 'ar':
          return "${tr("ago")} $weeks ${weeks > 1 && weeks <= 10 ? tr("weeks") : tr("week")}";
        case 'en':
          return "$weeks ${weeks > 1 ? tr("weeks") : tr("week")} ${tr("ago")}";
        default:
          return "$weeks ${weeks > 1 ? tr("weeks") : tr("week")} ${tr("ago")}";
      }
    }
    else if (inHours > 24){
      switch(lang){
        case 'ar':
          return "${tr("ago")} $inDays ${inDays > 1 && inDays <= 10 ? tr("days") : tr("day")}";
        case 'en':
          return "$inDays ${inDays > 1 ? tr("days"):tr("day")} ${tr("ago")}";
        default:
          return "$inDays ${inDays > 1 ? tr("days"):tr("day")} ${tr("ago")}";
      }
    }
    else if(inMinutes > 60){
      switch(lang){
        case 'ar':
          return "${tr("ago")} $inHours ${inHours > 1 && inHours <= 10 ? tr("hours") : tr("hour")}";
        case 'en':
          return "$inHours ${inHours > 1 ? tr("hours"):tr("hour")} ${tr("ago")}";
        default:
          return "$inHours ${inHours > 1 ? tr("hours"):tr("hour")} ${tr("ago")}";
      }

    }
    else if(inSeconds > 60){
      switch(lang){
        case 'ar':
          return "${tr("ago")} ${inMinutes > 1 && inMinutes <= 10 ? inMinutes.toString() + " " + tr("minutes") : tr("minute")}";
        case 'en':
          return "$inMinutes ${inMinutes > 1 ? tr("minutes"):tr("minute")} ${tr("ago")}";
        default:
        return "$inMinutes ${inMinutes > 1 ? tr("minutes"):tr("minute")} ${tr("ago")}";
      }

    }
    else{
      switch(lang){
        case 'ar':
          return "${tr("ago")} ${inSeconds > 1 && inSeconds <= 10 ? inSeconds.toString() + " " + tr("seconds") : tr("second")}";
        case 'en':
          return "$inSeconds ${inSeconds > 1 ? tr("seconds"):tr("second")} ${tr("ago")}";
        default:
        return "$inSeconds ${inSeconds > 1 ? tr("seconds"):tr("second")} ${("ago")}";
      }

    }
  }

  static Future<String> deviceID() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    IosDeviceInfo iosInfo;
    late String deviceID;
    if(Platform.isAndroid){
      androidInfo = await deviceInfo.androidInfo;
      deviceID = androidInfo.androidId;
      print(androidInfo.androidId);
    }
    if(Platform.isIOS){
      iosInfo = await deviceInfo.iosInfo;
      deviceID = iosInfo.identifierForVendor;
    }
    return deviceID;
  }
}
