class EmployeeWarning {
  final String warningTitle;
  final String warningNumber;
  final String action;

  EmployeeWarning({
    required this.warningTitle,
    required this.warningNumber,
    required this.action,
  });

  factory EmployeeWarning.fromJson(Map<String, dynamic> json) {
    return EmployeeWarning(
      warningTitle: json['warning_title'] ?? '',  // Default to empty string if missing
      warningNumber: json['warning_number'] ?? '',  // Default to empty string if missing
      action: json['action'] ?? '',  // Default to empty string if missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warning_title': warningTitle,
      'warning_number': warningNumber,
      'action': action,
    };
  }
}
