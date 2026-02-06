import 'dart:developer';

import 'package:diamate/core/services/push_notification/local_notfication_service.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/glucose/data/models/glucose_reading.dart';
import 'package:diamate/features/glucose/data/services/glucose_local_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'glucose_state.dart';

class GlucoseCubit extends Cubit<GlucoseState> {
  final GlucoseLocalService _localService;

  GlucoseCubit(this._localService) : super(GlucoseInitial()) {
    loadReadings();
  }

  final _uuid = const Uuid();
  List<GlucoseReading> _readings = [];

  Future<void> loadReadings() async {
    try {
      emit(GlucoseLoading());
      _readings = await _localService.getReadings();
      _readings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      emit(GlucoseLoaded(readings: _readings));
    } catch (e) {
      emit(GlucoseError(message: 'Failed to load readings: $e'));
    }
  }

  Future<void> addReading({
    required double value,
    required String source,
    String? imagePath,
    String? notes,
    String measurementType = 'random',
  }) async {
    try {
      final reading = GlucoseReading(
        id: _uuid.v4(),
        value: value,
        timestamp: DateTime.now(),
        source: source,
        imagePath: imagePath,
        notes: notes,
        measurementType: measurementType,
      );

      // Get advice based on the reading
      final advice = reading.advice;

      // Auto-append advice to notes if no custom note provided
      String? finalNotes = notes;
      if (finalNotes == null || finalNotes.isEmpty) {
        finalNotes = advice;
      } else {
        finalNotes = '$notes\n\n$advice';
      }

      // Create final reading with advice
      final finalReading = GlucoseReading(
        id: reading.id,
        value: reading.value,
        timestamp: reading.timestamp,
        source: reading.source,
        imagePath: reading.imagePath,
        notes: finalNotes,
        measurementType: reading.measurementType,
      );

      await _localService.addReading(finalReading);

      // Show notification with advice
      _showGlucoseNotification(finalReading);

      emit(GlucoseReadingAdded());
      await loadReadings();
    } catch (e) {
      emit(GlucoseError(message: 'Failed to add reading: $e'));
    }
  }

  void _showGlucoseNotification(GlucoseReading reading) async {
    try {
      final notificationService = sl<LocalNotificationService>();

      // Determine notification title based on status
      String title;
      if (reading.value < 54) {
        title = '🚨 CRITICAL: Very Low Glucose!';
      } else if (reading.value < 70) {
        title = '⚠️ LOW: Glucose Alert';
      } else if (reading.status.contains('Normal') ||
          reading.status.contains('EXCELLENT') ||
          reading.status.contains('GREAT')) {
        title = '✅ Glucose: ${reading.status}';
      } else if (reading.status.contains('Prediabetes')) {
        title = '⚠️ WARNING: Prediabetes Range';
      } else {
        title = '🚨 HIGH: Glucose Alert';
      }

      // Show notification with advice
      await notificationService.showSimpleNotification(
        title: title,
        body: reading.advice,
        payload: 'glucose_reading',
      );

      log(' Glucose notification sent: $title');
    } catch (e) {
      log('❌ Error showing glucose notification: $e');
    }
  }

  Future<void> deleteReading(int index) async {
    try {
      await _localService.deleteReading(index);
      await loadReadings();
    } catch (e) {
      emit(GlucoseError(message: 'Failed to delete reading: $e'));
    }
  }

  Future<void> deleteMultipleReadings(List<dynamic> keys) async {
    try {
      await _localService.deleteMultipleReadings(keys);
      await loadReadings();
    } catch (e) {
      emit(GlucoseError(message: 'Failed to delete readings: $e'));
    }
  }

  GlucoseReading? get latestReading {
    if (_readings.isNotEmpty) return _readings.first;
    return null;
  }

  double get averageReading {
    if (_readings.isEmpty) return 0;
    final sum = _readings.fold<double>(
      0,
      (sum, reading) => sum + reading.value,
    );
    return sum / _readings.length;
  }

  double get highestReading {
    if (_readings.isEmpty) return 0;
    return _readings.map((r) => r.value).reduce((a, b) => a > b ? a : b);
  }

  double get lowestReading {
    if (_readings.isEmpty) return 0;
    return _readings.map((r) => r.value).reduce((a, b) => a < b ? a : b);
  }

  List<GlucoseReading> get last7DaysReadings {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return _readings.where((r) => r.timestamp.isAfter(sevenDaysAgo)).toList();
  }
}
