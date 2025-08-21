import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'app_colors.dart';

class ThemeConfig {
  static const _font = 'Poppins';
  static ThemeData lightTheme() {
    ColorScheme colorScheme = const ColorScheme.light(
      primary: ColorsForApp.primaryColor,
      primaryFixedDim: ColorsForApp.primaryExtraLightColor,
      secondary: ColorsForApp.secondaryColor,
      secondaryFixedDim: ColorsForApp.secondaryExtraLightColor,
      tertiary: ColorsForApp.tertiaryColor,
      tertiaryFixedDim: ColorsForApp.tertiaryExtraLightColor,
      surface: Colors.white,
      surfaceBright: Color(0xFFF9FCFF),
      onSurfaceVariant: Color(0xFF121212),
      onSurface: Colors.black,
      surfaceContainer: Color(0xFFDCEEFF),
      inverseSurface: Color(0xFFFFCBCB),
      shadow: ColorsForApp.shadowColor,
    );
    return _createTheme(colorScheme);
  }

  static ThemeData darkTheme() {
    ColorScheme colorScheme = const ColorScheme.dark(
      primary: ColorsForApp.primaryColor,
      primaryFixedDim: ColorsForApp.primaryExtraLightColor,
      secondary: ColorsForApp.secondaryColor,
      secondaryFixedDim: ColorsForApp.secondaryExtraLightColor,
      tertiary: ColorsForApp.tertiaryColor,
      tertiaryFixedDim: ColorsForApp.tertiaryExtraLightColor,
      surface: Colors.black,
      surfaceBright: Color(0xFF121212),
      onSurface: Colors.white,
      onSurfaceVariant: Color(0xFFF9FCFF),
      surfaceContainer: Color(0xFF001F3D),
      inverseSurface: Color(0xFF00274D),
      shadow: Color(0xff494949),
    );
    return _createTheme(colorScheme);
  }

  static ThemeData _createTheme(ColorScheme colorScheme) {
    TextTheme textTheme = _createTextTheme(colorScheme);
    return ThemeData(
      fontFamily: _font,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      dialogBackgroundColor: colorScheme.surface,
      useMaterial3: true,
      splashColor: colorScheme.secondary,
      textTheme: textTheme,
      switchTheme: _createSwitchTheme(colorScheme),
      radioTheme: _createRadioTheme(colorScheme),
      checkboxTheme: _createCheckboxTheme(colorScheme),
      textButtonTheme: _createTextButtonTheme(colorScheme),
      appBarTheme: _createAppBarTheme(colorScheme),
      bottomNavigationBarTheme: _createBottomNavigationBarTheme(colorScheme),
      inputDecorationTheme: _createInputDecorationTheme(
        colorScheme,
        textTheme,
      ),
      textSelectionTheme: _createTextSelectionTheme(colorScheme),
      listTileTheme: _createListTileTheme(colorScheme),
      dialogTheme: _createDialogTheme(colorScheme),
      bottomSheetTheme: _createBottomSheetTheme(colorScheme),
      dividerTheme: _createDividerTheme(colorScheme),
      buttonTheme: _createButtonTheme(colorScheme),
      snackBarTheme: _createSnackBarTheme(colorScheme),
      datePickerTheme: _createDatePickerTheme(colorScheme),
      sliderTheme: const SliderThemeData(
        minThumbSeparation: 0.5,
        trackShape: RoundedRectSliderTrackShape(),
      ),
      scrollbarTheme: const ScrollbarThemeData(
        radius: Radius.circular(100),
      ),
    );
  }

  static TextTheme _createTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: TextStyle(fontFamily: _font, fontSize: 28.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      displayMedium: TextStyle(fontFamily: _font, fontSize: 26.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      displaySmall: TextStyle(fontFamily: _font, fontSize: 24.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      headlineLarge: TextStyle(fontFamily: _font, fontSize: 22.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      headlineMedium: TextStyle(fontFamily: _font, fontSize: 20.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      headlineSmall: TextStyle(fontFamily: _font, fontSize: 18.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      titleLarge: TextStyle(fontFamily: _font, fontSize: 16.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      titleMedium: TextStyle(fontFamily: _font, fontSize: 15.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      titleSmall: TextStyle(fontFamily: _font, fontSize: 14.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(fontFamily: _font, fontSize: 13.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontFamily: _font, fontSize: 12.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontFamily: _font, fontSize: 11.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      labelLarge: TextStyle(fontFamily: _font, fontSize: 10.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      labelMedium: TextStyle(fontFamily: _font, fontSize: 9.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
      labelSmall: TextStyle(fontFamily: _font, fontSize: 8.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal),
    );
  }

  static SwitchThemeData _createSwitchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      thumbColor: WidgetStateProperty.all(colorScheme.onSurface),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled) || states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.surface;
      }),
    );
  }

  static RadioThemeData _createRadioTheme(ColorScheme colorScheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onSurface.withOpacity(0.5);
      }),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      overlayColor: WidgetStateProperty.all(colorScheme.surface),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }

  static CheckboxThemeData _createCheckboxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surface;
      }),
      side: BorderSide(width: 1.5, color: colorScheme.onSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      checkColor: WidgetStateProperty.all(colorScheme.surface),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }

  static TextButtonThemeData _createTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(colorScheme.surface),
        foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
      ),
    );
  }

  static AppBarTheme _createAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      scrolledUnderElevation: 0,
      elevation: 0,
      iconTheme: IconThemeData(size: 16.sp, color: colorScheme.surface),
      actionsIconTheme: IconThemeData(size: 16.sp, color: colorScheme.surface),
      titleTextStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: colorScheme.surface),
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      foregroundColor: colorScheme.onSurface,
      backgroundColor: colorScheme.primary,
    );
  }

  static BottomNavigationBarThemeData _createBottomNavigationBarTheme(ColorScheme colorScheme) {
    return BottomNavigationBarThemeData(
      elevation: 0,
      enableFeedback: false,
      backgroundColor: colorScheme.primary,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: colorScheme.primary,
      selectedIconTheme: IconThemeData(size: 18.sp),
      unselectedIconTheme: IconThemeData(size: 16.sp),
      unselectedItemColor: colorScheme.onSurface.withOpacity(0.75),
      selectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: colorScheme.primaryFixedDim),
      unselectedLabelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: colorScheme.onSurface.withOpacity(0.75)),
    );
  }

  static InputDecorationTheme _createInputDecorationTheme(ColorScheme colorScheme, TextTheme textTheme) {
    return InputDecorationTheme(
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.surface, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.shadow),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.shadow),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.shadow, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      counterStyle: textTheme.bodyMedium,
      labelStyle: textTheme.titleSmall,
      hintStyle: textTheme.bodyLarge,
      filled: true,
      fillColor: colorScheme.surface,
    );
  }

  static ListTileThemeData _createListTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      titleTextStyle: TextStyle(color: colorScheme.onSurface),
      tileColor: colorScheme.surface,
      iconColor: colorScheme.onSurface,
    );
  }

  static DialogThemeData _createDialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      titleTextStyle: TextStyle(
        fontFamily: _font,
        fontSize: 14.sp,
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        fontFamily: _font,
        fontSize: 11.sp,
        color: colorScheme.onSurfaceVariant.withOpacity(0.8),
      ),
    );
  }

  static BottomSheetThemeData _createBottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      modalBackgroundColor: colorScheme.surface,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
    );
  }

  static DividerThemeData _createDividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.onSurface.withOpacity(0.4),
      thickness: 0.5,
    );
  }

  static ButtonThemeData _createButtonTheme(ColorScheme colorScheme) {
    return ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      colorScheme: colorScheme,
      height: 52,
    );
  }

  static SnackBarThemeData _createSnackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.primary,
      contentTextStyle: TextStyle(color: colorScheme.onSurface),
      elevation: 20,
    );
  }

  static DatePickerThemeData _createDatePickerTheme(ColorScheme colorScheme) {
    return DatePickerThemeData(
      dayStyle: TextStyle(fontSize: 10.sp, color: colorScheme.onSurfaceVariant),
      yearStyle: TextStyle(fontSize: 10.sp, color: colorScheme.onSurfaceVariant),
      weekdayStyle: TextStyle(fontSize: 12.sp, color: colorScheme.onSurfaceVariant),
      headerBackgroundColor: colorScheme.primary,
      inputDecorationTheme: InputDecorationTheme(
        helperStyle: TextStyle(color: colorScheme.onSurface),
        errorStyle: TextStyle(color: colorScheme.onSurface),
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),
      rangePickerShape: Border.all(color: Colors.transparent),
      headerHelpStyle: TextStyle(fontSize: 12.sp, color: colorScheme.onSurfaceVariant),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
    );
  }

  static _createTextSelectionTheme(ColorScheme colorScheme) {
    return TextSelectionThemeData(
      cursorColor: colorScheme.onSurfaceVariant,
    );
  }
}
