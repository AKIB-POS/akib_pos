class SalarySlipDetail {
  final double totalSalaryReceived;
  final double totalBonus;
  final List<SalaryDetailItem> earningsDetails;
  final List<SalaryDetailItem> deductionsDetails;

  SalarySlipDetail({
    required this.totalSalaryReceived,
    required this.totalBonus,
    required this.earningsDetails,
    required this.deductionsDetails,
  });

  factory SalarySlipDetail.fromJson(Map<String, dynamic> json) {
    return SalarySlipDetail(
      totalSalaryReceived: json['total_salary_received'].toDouble(),
      totalBonus: json['total_bonus'].toDouble(),
      earningsDetails: (json['earnings_details'] as List)
          .map((e) => SalaryDetailItem.fromJson(e))
          .toList(),
      deductionsDetails: (json['deductions_details'] as List)
          .map((e) => SalaryDetailItem.fromJson(e))
          .toList(),
    );
  }
}

class SalaryDetailItem {
  final String name;
  final double amount;

  SalaryDetailItem({
    required this.name,
    required this.amount,
  });

  factory SalaryDetailItem.fromJson(Map<String, dynamic> json) {
    return SalaryDetailItem(
      name: json['name'],
      amount: json['amount'].toDouble(),
    );
  }
}
