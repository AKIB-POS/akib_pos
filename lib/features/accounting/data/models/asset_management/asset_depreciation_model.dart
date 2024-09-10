class AssetsDepreciationModel {
  final String dateRange;
  final String assetName;
  final String invoiceNumber;
  final String usefulLife;
  final double valuePerYear;
  final double accumulatedDepreciation;

  AssetsDepreciationModel({
    required this.dateRange,
    required this.assetName,
    required this.invoiceNumber,
    required this.usefulLife,
    required this.valuePerYear,
    required this.accumulatedDepreciation,
  });

  factory AssetsDepreciationModel.fromJson(Map<String, dynamic> json) {
    return AssetsDepreciationModel(
      dateRange: json['date_range'],
      assetName: json['asset_name'],
      invoiceNumber: json['invoice_number'],
      usefulLife: json['useful_life'],
      valuePerYear: json['value_per_year'].toDouble(),
      accumulatedDepreciation: json['accumulated_depreciation'].toDouble(),
    );
  }
}
