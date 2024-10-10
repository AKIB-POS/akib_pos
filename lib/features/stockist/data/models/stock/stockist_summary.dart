class StockistSummaryRequest {
  final int branchId;

  StockistSummaryRequest({required this.branchId});

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
    };
  }
}


class StockistSummaryResponse {
  final int totalMaterials;
  final int expiredStockCount;
  final int runningOutStockCount;

  StockistSummaryResponse({
    required this.totalMaterials,
    required this.expiredStockCount,
    required this.runningOutStockCount,
  });

  factory StockistSummaryResponse.fromJson(Map<String, dynamic> json) {
    return StockistSummaryResponse(
      totalMaterials: json['total_materials'] ?? 0,
      expiredStockCount: json['expired_stock_count'] ?? 0,
      runningOutStockCount: json['running_out_stock_count'] ?? 0,
    );
  }
}

