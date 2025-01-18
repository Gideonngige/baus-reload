import 'package:baustaka/config/fonts.dart';
import 'package:baustaka/config/palette.dart';
import 'package:flutter/material.dart';

var _baseTheme = ThemeData.light();

final kAppTheme = ThemeData(
  brightness: _baseTheme.brightness,
  primaryColor: Palette.primary,
  fontFamily: Fonts.kSemiBold,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  splashColor: Palette.primary,
  highlightColor: Palette.primary,
  scaffoldBackgroundColor: Colors.white,
  indicatorColor: Palette.primary,
  appBarTheme: _baseTheme.appBarTheme.copyWith(
    iconTheme: const IconThemeData(
      color: Palette.primary,
    ),
    actionsIconTheme: const IconThemeData(
      color: Palette.primary,
    ),
    centerTitle: false,
    titleTextStyle: const TextStyle(
      color: Palette.primary,
      fontSize: 20,
      fontFamily: Fonts.kBold,
      fontWeight: FontWeight.w900,
    ),
    toolbarTextStyle: const TextStyle(
      color: Palette.primary,
      fontSize: 20,
      fontFamily: Fonts.kBold,
      fontWeight: FontWeight.w900,
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  hintColor: Colors.grey,
  textTheme: _baseTheme.textTheme
      .apply(
        fontFamily: Fonts.kSemiBold,
      )
      .copyWith(
        titleMedium: const TextStyle(
          fontFamily: Fonts.kSemiBold,
          color: Palette.textPrimary,
        ),
        titleSmall: const TextStyle(
          fontFamily: Fonts.kSemiBold,
          color: Palette.textSecondary,
        ),
        displayLarge: const TextStyle(
          fontFamily: Fonts.kBold,
          color: Palette.textPrimary,
        ),
        displayMedium: const TextStyle(
          fontFamily: Fonts.kBold,
          color: Palette.textPrimary,
        ),
        displaySmall: const TextStyle(
          fontFamily: Fonts.kBold,
          color: Palette.textPrimary,
        ),
        headlineMedium: const TextStyle(
          fontFamily: Fonts.kBold,
          color: Palette.textPrimary,
        ),
        headlineSmall: const TextStyle(
          fontFamily: Fonts.kBold,
          color: Palette.textPrimary,
        ),
        titleLarge: const TextStyle(
          fontFamily: Fonts.kBold,
          color: Palette.textPrimary,
        ),
        bodyLarge: const TextStyle(
          fontFamily: Fonts.kSemiBold,
          color: Palette.textPrimary,
        ),
        bodyMedium: const TextStyle(
          fontFamily: Fonts.kSemiBold,
          color: Palette.textPrimary,
        ),
        bodySmall: const TextStyle(
          fontFamily: Fonts.kSemiBold,
          color: Palette.textSecondary,
        ),
        labelSmall: const TextStyle(
          fontFamily: Fonts.kSemiBold,
          color: Palette.textSecondary,
        ),
      ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(64, 48),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      backgroundColor: Palette.primary,
      foregroundColor: Colors.white,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(64, 48),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      foregroundColor: Palette.primary,
      side: const BorderSide(
        color: Palette.stroke,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(64, 48),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      foregroundColor: Palette.primary,
      surfaceTintColor: Palette.primary,
      iconColor: Palette.primary,
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    labelColor: Palette.primary,
    unselectedLabelColor: Palette.textSecondary,
    labelStyle: const TextStyle(
      fontFamily: Fonts.kBold,
      fontSize: 16,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w700,
      color: Palette.primary,
    ),
    unselectedLabelStyle: const TextStyle(
      fontFamily: Fonts.kBold,
      fontSize: 16,
      letterSpacing: 0.15,
      color: Palette.textSecondary,
    ),
    indicator: UnderlineTabIndicator(
      borderRadius: BorderRadius.circular(2),
      borderSide: const BorderSide(
        color: Palette.primary,
        width: 4,
      ),
    ),
    dividerHeight: 0,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Palette.primary,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  ),
  useMaterial3: true,
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade100,
  ),
);

final kInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(kDefaultRadius),
  ),
);

const kLinearGradient = LinearGradient(
  colors: [
    Palette.secondary,
    Palette.primary,
  ],
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
);

const kDefaultRadius = 12.0;
