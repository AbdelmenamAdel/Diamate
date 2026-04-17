import 'dart:developer';
import 'dart:io';
import 'package:vision_text_recognition/vision_text_recognition.dart';

class OCRService {
  /// Extract full text from image
  Future<String> extractTextFromImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final result = await VisionTextRecognition.recognizeText(imageBytes);
    return result.fullText;
  }

  /// Extract glucose value only
  Future<int?> extractGlucoseValue(File imageFile) async {
    final text = await extractTextFromImage(imageFile);
    log('OCR Extracted Text: $text');

    // Normalize text: lowercase and simplify spacing
    final normalizedText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    // 1. Try to find number with explicit units (most reliable)
    // Matches patterns like "120 mg/dl" or "5.6 mmol/l"
    final mgDlPattern = RegExp(r'(\d{2,3})\s*(mg/dl|mg/bl|mg/v|mg/i|mgdl)');
    final mmolPattern = RegExp(r'(\d{1,2}\.?\d?)\s*(mmol/l|mmol)');

    // Check for mmol first (more likely to have decimals)
    final mmolMatch = mmolPattern.firstMatch(normalizedText);
    if (mmolMatch != null) {
      final value = double.tryParse(mmolMatch.group(1)!);
      if (value != null && value >= 1.0 && value <= 40.0) {
        log('Detected mmol/L: $value');
        return (value * 18.0).round(); // Convert to mg/dL
      }
    }

    // Check for mg/dL
    final mgDlMatch = mgDlPattern.firstMatch(normalizedText);
    if (mgDlMatch != null) {
      final value = int.tryParse(mgDlMatch.group(1)!);
      if (value != null && value >= 30 && value <= 600) {
        log('Detected mg/dL: $value');
        return value;
      }
    }

    // 2. Fallback: Search for any realistic numbers if units weren't explicitly found
    final numberMatches =
        RegExp(r'(\d{1,3}(\.\d{1,2})?)').allMatches(normalizedText);

    List<double> candidates = [];
    for (final match in numberMatches) {
      final valStr = match.group(0)!;
      final value = double.tryParse(valStr);
      if (value == null) continue;

      // Realistic mg/dL range (integers normally)
      if (!valStr.contains('.') && value >= 40 && value <= 500) {
        // Heuristic: Avoid common time/date false positives
        bool isLikelyTime = normalizedText.contains(RegExp('$valStr\\s*[:/-]')) ||
            normalizedText.contains(RegExp('[:/-]\\s*$valStr'));
        
        if (!isLikelyTime) {
          candidates.add(value);
        }
      }

      // Realistic mmol/L range (usually has decimal)
      if (valStr.contains('.') && value >= 2.0 && value <= 30.0) {
        candidates.add(value * 18.0); // Convert and add as candidate
      }
    }

    if (candidates.isNotEmpty) {
      // If we have candidates, return the most plausible one
      // Usually the glucose reading is unique or the largest after filtering
      // For now, return the first one found as it's often the main reading
      log('Detected candidates: $candidates');
      return candidates.first.round();
    }

    return null;
  }

  /// Dispose (Not required for vision_text_recognition as it uses static methods)
  void dispose() {}
}
