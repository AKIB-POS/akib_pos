class ActiveAssetModel {
  final String date;
  final String assetName;
  final String assetAccountNumber;
  final String assetAccountCode;
  final double accumulatedCost;
  final double bookValue;

  ActiveAssetModel({
    required this.date,
    required this.assetName,
    required this.assetAccountNumber,
    required this.assetAccountCode,
    required this.accumulatedCost,
    required this.bookValue,
  });

  factory ActiveAssetModel.fromJson(Map<String, dynamic> json) {
    return ActiveAssetModel(
      date: json['date'],
      assetName: json['asset_name'],
      assetAccountNumber: json['asset_account_number'],
      assetAccountCode: json['asset_account_code'],
      accumulatedCost: (json['accumulated_cost'] as num).toDouble(),
      bookValue: (json['book_value'] as num).toDouble(),
    );
  }
}
