class TotalExpenditureModel {
  final double totalExpenditure;

  TotalExpenditureModel({
    required this.totalExpenditure,
  });

  factory TotalExpenditureModel.fromJson(Map<String, dynamic> json) {
    return TotalExpenditureModel(
      totalExpenditure: json['total_expenditure'],
    );
  }
}
