import 'package:diamate/core/language/app_Localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArShortMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'الآن';
  @override
  String aboutAMinute(int minutes) => '1 د';
  @override
  String minutes(int minutes) => '$minutes د';
  @override
  String aboutAnHour(int minutes) => '1 س';
  @override
  String hours(int hours) => '$hours س';
  @override
  String aDay(int hours) => '1 ي';
  @override
  String days(int days) => '$days ي';
  @override
  String aboutAMonth(int days) => '1 ش';
  @override
  String months(int months) => '$months ش';
  @override
  String aboutAYear(int years) => '1 ع';
  @override
  String years(int years) => '$years ع';
  @override
  String wordSeparator() => ' ';
}

class EnShortMessages extends timeago.EnShortMessages {
  @override
  String lessThanOneMinute(int seconds) => 'now';
}

class TimeAgo {
  /// Initialize custom timeago locales
  static void setup() {
    timeago.setLocaleMessages('en_short', EnShortMessages());
    timeago.setLocaleMessages('ar_short', ArShortMessages());
  }

  /// Format date to "time ago" string based on current locale
  static String format(DateTime date, BuildContext context) {
    final isEn = AppLocalizations.of(context)?.isEnLocale ?? true;
    return timeago.format(date, locale: isEn ? 'en_short' : 'ar_short');
  }

  /// Format date to "time ago - absolute date" string based on current locale
  static String formatWithDate(DateTime date, BuildContext context) {
    final isEn = AppLocalizations.of(context)?.isEnLocale ?? true;
    final timeAgoStr = format(date, context);
    final dateStr = isEn
        ? DateFormat('MMM dd, yyyy').format(date)
        : DateFormat.yMMMd('ar').format(date);
    return "$timeAgoStr - $dateStr";
  }
}
