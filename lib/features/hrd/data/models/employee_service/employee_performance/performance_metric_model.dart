class PerformanceMetricModel {
  final int metricsId;
  final String metricsName;

  PerformanceMetricModel({
    required this.metricsId,
    required this.metricsName,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory PerformanceMetricModel.fromJson(Map<String, dynamic> json) {
    return PerformanceMetricModel(
      metricsId: json['metrics_id'],
      metricsName: json['metrics_name'],
    );
  }

  // Method untuk mengkonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'metrics_id': metricsId,
      'metrics_name': metricsName,
    };
  }
}
