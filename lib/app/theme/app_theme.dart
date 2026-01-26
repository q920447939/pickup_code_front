import 'package:flutter/material.dart';

class AppTheme {
  // A "fresh" palette inspired by the reference screenshot:
  // bright green accent, clean surfaces, soft background, light outlines.
  static const _ink = Color(0xFF111111);
  static const _mutedInk = Color(0xFF6B7280);
  static const _bg = Color(0xFFF6F5F2);
  static const _surface = Color(0xFFFFFFFF);

  static const _primary = Color(0xFF7CFF6B);
  static const _secondary = Color(0xFF66C7FF);

  static const _danger = Color(0xFFD32F2F);

  // ~15% ink outline, used for cards/inputs/buttons borders.
  static const _outline = Color(0x26111111);
  static const _outlineStrong = Color(0x33111111);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: _primary,
      onPrimary: _ink,
      primaryContainer: Color(0xFFD9FFD3),
      onPrimaryContainer: _ink,
      secondary: _secondary,
      onSecondary: _ink,
      secondaryContainer: Color(0xFFD7F1FF),
      onSecondaryContainer: _ink,
      surface: _surface,
      onSurface: _ink,
      surfaceContainerHighest: Color(0xFFF2F4F7),
      outline: _outline,
      outlineVariant: _outlineStrong,
      error: _danger,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: _bg,
    dividerColor: _outline,
    splashFactory: InkSparkle.splashFactory,

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: _ink,
      titleTextStyle: TextStyle(
        color: _ink,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    textTheme: Typography.material2021().black.apply(
      bodyColor: _ink,
      displayColor: _ink,
    ),

    cardTheme: const CardThemeData(
      color: _surface,
      elevation: 0,
      shadowColor: Color(0x14000000),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        side: BorderSide(color: _outline, width: 1.2),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: _ink,
      textColor: _ink,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: TextStyle(color: _mutedInk),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: _outline, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: _outline, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: _ink, width: 1.2),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _surface,
      selectedColor: _primary,
      secondarySelectedColor: _primary,
      disabledColor: const Color(0xFFE5E7EB),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      labelStyle: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
      secondaryLabelStyle: const TextStyle(
        color: _ink,
        fontWeight: FontWeight.w700,
      ),
      shape: const StadiumBorder(side: BorderSide(color: _outline, width: 1.2)),
      showCheckmark: false,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFFE5E7EB);
          }
          return _primary;
        }),
        foregroundColor: const WidgetStatePropertyAll(_ink),
        overlayColor: const WidgetStatePropertyAll(Color(0x14111111)),
        elevation: const WidgetStatePropertyAll(0),
        side: const WidgetStatePropertyAll(
          BorderSide(color: _ink, width: 1.2),
        ),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(_ink),
        overlayColor: const WidgetStatePropertyAll(Color(0x14111111)),
        side: const WidgetStatePropertyAll(
          BorderSide(color: _outlineStrong, width: 1.2),
        ),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(_ink),
        overlayColor: const WidgetStatePropertyAll(Color(0x14111111)),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(_ink),
        overlayColor: const WidgetStatePropertyAll(Color(0x14111111)),
        shape: const WidgetStatePropertyAll(
          CircleBorder(side: BorderSide(color: _outline, width: 1.2)),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(10)),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: _ink,
      elevation: 0,
      shape: StadiumBorder(side: BorderSide(color: _ink, width: 1.2)),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return _primary;
        return _surface;
      }),
      checkColor: const WidgetStatePropertyAll(_ink),
      side: const BorderSide(color: _outlineStrong, width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return _ink;
        return _surface;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return _primary;
        return const Color(0xFFE5E7EB);
      }),
      trackOutlineColor: const WidgetStatePropertyAll(_outlineStrong),
    ),

    dialogTheme: const DialogThemeData(
      backgroundColor: _surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        side: BorderSide(color: _outline, width: 1.2),
      ),
      titleTextStyle: TextStyle(
        color: _ink,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: TextStyle(color: _ink, fontSize: 14),
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _ink,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );

}
