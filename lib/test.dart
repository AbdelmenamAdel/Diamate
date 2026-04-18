import 'dart:developer';

import 'package:dio/dio.dart';

Future getData() async {
  try {
    log("Starting getData...");
    var id = "8718e040";
    var appKey = "971cb341a0f6f26293f476a23e1177c0";
    var response = await Dio().get(
      "https://api.edamam.com/api/recipes/v2?type=public&q=chicken&app_id=$id&app_key=$appKey",
    );
    log("Response: ${response.toString()}");
  } catch (e) {
    log("Error in getData: $e");
  }
}

// Mocking the behavior for testing logic
int? extractGlucoseValueLogic(String text) {
  print('Testing text: "$text"');

  // Normalize text: lowercase and simplify spacing
  final normalizedText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  // 1. Try to find number with explicit units (most reliable)
  final mgDlPattern = RegExp(r'(\d{2,3})\s*(mg/dl|mg/bl|mg/v|mg/i|mgdl)');
  final mmolPattern = RegExp(r'(\d{1,2}\.?\d?)\s*(mmol/l|mmol)');

  final mmolMatch = mmolPattern.firstMatch(normalizedText);
  if (mmolMatch != null) {
    final value = double.tryParse(mmolMatch.group(1)!);
    if (value != null && value >= 1.0 && value <= 40.0) {
      return (value * 18.0).round();
    }
  }

  final mgDlMatch = mgDlPattern.firstMatch(normalizedText);
  if (mgDlMatch != null) {
    final value = int.tryParse(mgDlMatch.group(1)!);
    if (value != null && value >= 30 && value <= 600) {
      return value;
    }
  }

  // 2. Fallback
  final numberMatches = RegExp(
    r'(\d{1,3}(\.\d{1,2})?)',
  ).allMatches(normalizedText);

  List<double> candidates = [];
  for (final match in numberMatches) {
    final valStr = match.group(0)!;
    final value = double.tryParse(valStr);
    if (value == null) continue;

    if (!valStr.contains('.') && value >= 40 && value <= 500) {
      bool isLikelyTime =
          normalizedText.contains(RegExp('$valStr\\s*[:/-]')) ||
          normalizedText.contains(RegExp('[:/-]\\s*$valStr'));

      if (!isLikelyTime) {
        candidates.add(value);
      }
    }

    if (valStr.contains('.') && value >= 2.0 && value <= 30.0) {
      candidates.add(value * 18.0);
    }
  }

  if (candidates.isNotEmpty) {
    return candidates.first.round();
  }

  return null;
}

void main() {
  final testCases = {
    "120 mg/dL": 120,
    "5.6 mmol/L": 101, // 5.6 * 18 = 100.8
    "Glucose: 150 mg/dl": 150,
    "Current 110 mg/dL Time 12:30": 110,
    "17/04/2026 14:20 135 mg/dL": 135,
    "8.0 mmol": 144,
    "Just a number 125": 125,
    "Time 08:50 Reading 100": 100, // Should NOT pick up 50
    "5,6 mmol/L":
        null, // Currently doesn't handle commas, but regex could be improved if needed
  };

  testCases.forEach((text, expected) {
    final result = extractGlucoseValueLogic(text);
    if (result == expected) {
      print('✅ PASS: "$text" -> $result');
    } else {
      print('❌ FAIL: "$text" -> Expected $expected, got $result');
    }
  });
}
