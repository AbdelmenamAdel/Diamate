class DfuPredictionResponse {
  final bool ulcerDetected;
  final int ulcerPixels;
  final int totalPixels;
  final double ulcerCoverage;
  final double inferenceMs;
  final String maskB64;
  final String overlayB64;

  DfuPredictionResponse({
    required this.ulcerDetected,
    required this.ulcerPixels,
    required this.totalPixels,
    required this.ulcerCoverage,
    required this.inferenceMs,
    required this.maskB64,
    required this.overlayB64,
  });

  factory DfuPredictionResponse.fromJson(Map<String, dynamic> json) {
    return DfuPredictionResponse(
      ulcerDetected: json['ulcer_detected'] ?? false,
      ulcerPixels: json['ulcer_pixels'] ?? 0,
      totalPixels: json['total_pixels'] ?? 0,
      ulcerCoverage: (json['ulcer_coverage'] ?? 0.0).toDouble(),
      inferenceMs: (json['inference_ms'] ?? 0.0).toDouble(),
      maskB64: json['mask_b64'] ?? '',
      overlayB64: json['overlay_b64'] ?? '',
    );
  }
}
