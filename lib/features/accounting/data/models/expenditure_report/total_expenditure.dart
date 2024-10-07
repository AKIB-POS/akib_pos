class TotalExpenditureModel {
  final double totalExpenditure;

  TotalExpenditureModel({
    required this.totalExpenditure,
  });

  factory TotalExpenditureModel.fromJson(Map<String, dynamic> json) {
    return TotalExpenditureModel(
      totalExpenditure: (json['total_expenditure'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_expenditure': totalExpenditure,
    };
  }
}
