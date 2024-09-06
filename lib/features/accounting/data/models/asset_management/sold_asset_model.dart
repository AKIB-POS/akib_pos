class SoldAssetModel {
  final String date;
  final String assetDetail;
  final String invoiceNumber;
  final String transactionNumber;
  final double salePrice;
  final double profitLoss;

  SoldAssetModel({
    required this.date,
    required this.assetDetail,
    required this.invoiceNumber,
    required this.transactionNumber,
    required this.salePrice,
    required this.profitLoss,
  });

  factory SoldAssetModel.fromJson(Map<String, dynamic> json) {
    return SoldAssetModel(
      date: json['date'],
      assetDetail: json['asset_detail'],
      invoiceNumber: json['invoice_number'],
      transactionNumber: json['transaction_number'],
      salePrice: json['sale_price'],
      profitLoss: json['profit_loss'],
    );
  }
}
