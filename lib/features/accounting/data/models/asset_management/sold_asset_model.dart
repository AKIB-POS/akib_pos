class SoldAssetModel {
  final String date;
  final String assetDetail;
  final int invoiceNumber;
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
      date: json['date'] ?? '',
      assetDetail: json['asset_detail'] ?? '',
      invoiceNumber: (json['invoice_number'] as num).toInt() ?? 0,
      transactionNumber: json['transaction_number'] ?? '',
      salePrice: (json['sale_price'] as num?)?.toDouble() ?? 0.0,
      profitLoss: (json['profit_loss'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'asset_detail': assetDetail,
      'invoice_number': invoiceNumber,
      'transaction_number': transactionNumber,
      'sale_price': salePrice,
      'profit_loss': profitLoss,
    };
  }
}
