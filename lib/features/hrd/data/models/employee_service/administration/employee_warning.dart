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
      warningTitle: json['warning_title'],
      warningNumber: json['warning_number'],
      action: json['action'],
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
