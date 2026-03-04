import 'package:flutter/widgets.dart';

class AppLocaleController {
  AppLocaleController._();

  /// `null` means: follow system locale.
  static final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(null);

  static void setEnglish() => locale.value = const Locale('en');

  static void setVietnamese() => locale.value = const Locale('vi');

  static void followSystem() => locale.value = null;
}
