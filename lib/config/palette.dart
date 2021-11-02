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
}
