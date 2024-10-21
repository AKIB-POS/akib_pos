class FinancialBalanceModel {
  final Assets assets;
  final LiabilitiesAndOwnerEquity liabilitiesAndOwnerEquity;
  final double totalAssets;
  final double totalLiabilitiesAndEquity;

  FinancialBalanceModel({
    required this.assets,
    required this.liabilitiesAndOwnerEquity,
    required this.totalAssets,
    required this.totalLiabilitiesAndEquity,
  });

  factory FinancialBalanceModel.fromJson(Map<String, dynamic> json) {
    return FinancialBalanceModel(
      assets: Assets.fromJson(json['assets']),
      liabilitiesAndOwnerEquity: LiabilitiesAndOwnerEquity.fromJson(json['liabilities_and_owner_equity']),
      totalAssets: (json['total_assets'] as num?)?.toDouble() ?? 0.0,
      totalLiabilitiesAndEquity: (json['total_liabilities_and_equity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assets': assets.toJson(),
      'liabilities_and_owner_equity': liabilitiesAndOwnerEquity.toJson(),
      'total_assets': totalAssets,
      'total_liabilities_and_equity': totalLiabilitiesAndEquity,
    };
  }
}

class Assets {
  final List<AssetItem> currentAssets;
  final List<AssetItem> fixedAssets;

  Assets({required this.currentAssets, required this.fixedAssets});

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
      currentAssets: (json['current_assets'] as List)
          .map((item) => AssetItem.fromJson(item))
          .toList(),
      fixedAssets: (json['fixed_assets'] as List)
          .map((item) => AssetItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_assets': currentAssets.map((item) => item.toJson()).toList(),
      'fixed_assets': fixedAssets.map((item) => item.toJson()).toList(),
    };
  }
}

class LiabilitiesAndOwnerEquity {
  final List<AssetItem> currentLiabilities;
  final List<AssetItem> longTermLiabilities;
  final List<AssetItem> ownerEquity;

  LiabilitiesAndOwnerEquity({
    required this.currentLiabilities,
    required this.longTermLiabilities,
    required this.ownerEquity,
  });

  factory LiabilitiesAndOwnerEquity.fromJson(Map<String, dynamic> json) {
    return LiabilitiesAndOwnerEquity(
      currentLiabilities: (json['current_liabilities'] as List)
          .map((item) => AssetItem.fromJson(item))
          .toList(),
      longTermLiabilities: (json['long_term_liabilities'] as List)
          .map((item) => AssetItem.fromJson(item))
          .toList(),
      ownerEquity: (json['owner_equity'] as List)
          .map((item) => AssetItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_liabilities': currentLiabilities.map((item) => item.toJson()).toList(),
      'long_term_liabilities': longTermLiabilities.map((item) => item.toJson()).toList(),
      'owner_equity': ownerEquity.map((item) => item.toJson()).toList(),
    };
  }
}

class AssetItem {
  final String name;
  final double balance;

  AssetItem({required this.name, required this.balance});

  factory AssetItem.fromJson(Map<String, dynamic> json) {
    return AssetItem(
      name: json['name'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'balance': balance,
    };
  }
}
