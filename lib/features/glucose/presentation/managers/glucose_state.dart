part of 'glucose_cubit.dart';

abstract class GlucoseState extends Equatable {
  const GlucoseState();

  @override
  List<Object?> get props => [];
}

class GlucoseInitial extends GlucoseState {}

class GlucoseLoading extends GlucoseState {}

class GlucoseLoaded extends GlucoseState {
  final List<GlucoseReading> readings;

  const GlucoseLoaded({required this.readings});

  @override
  List<Object?> get props => [readings];
}

class GlucoseReadingAdded extends GlucoseState {}

class GlucoseError extends GlucoseState {
  final String message;

  const GlucoseError({required this.message});

  @override
  List<Object?> get props => [message];
}
