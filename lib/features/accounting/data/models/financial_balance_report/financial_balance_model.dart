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
  final CurrentAssets currentAssets;
  final FixedAssets fixedAssets;

  Assets({required this.currentAssets, required this.fixedAssets});

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
      currentAssets: CurrentAssets.fromJson(json['current_assets']),
      fixedAssets: FixedAssets.fromJson(json['fixed_assets']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_assets': currentAssets.toJson(),
      'fixed_assets': fixedAssets.toJson(),
    };
  }
}

class CurrentAssets {
  final double cash;
  final double inventory;

  CurrentAssets({required this.cash, required this.inventory});

  factory CurrentAssets.fromJson(Map<String, dynamic> json) {
    return CurrentAssets(
      cash: (json['cash'] as num?)?.toDouble() ?? 0.0,
      inventory: (json['inventory'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cash': cash,
      'inventory': inventory,
    };
  }
}

class FixedAssets {
  final double buildingValue;

  FixedAssets({required this.buildingValue});

  factory FixedAssets.fromJson(Map<String, dynamic> json) {
    return FixedAssets(
      buildingValue: (json['building_value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'building_value': buildingValue,
    };
  }
}

class LiabilitiesAndOwnerEquity {
  final CurrentLiabilities currentLiabilities;
  final OwnerEquity ownerEquity;

  LiabilitiesAndOwnerEquity({required this.currentLiabilities, required this.ownerEquity});

  factory LiabilitiesAndOwnerEquity.fromJson(Map<String, dynamic> json) {
    return LiabilitiesAndOwnerEquity(
      currentLiabilities: CurrentLiabilities.fromJson(json['current_liabilities']),
      ownerEquity: OwnerEquity.fromJson(json['owner_equity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_liabilities': currentLiabilities.toJson(),
      'owner_equity': ownerEquity.toJson(),
    };
  }
}

class CurrentLiabilities {
  final double tradePayables;

  CurrentLiabilities({required this.tradePayables});

  factory CurrentLiabilities.fromJson(Map<String, dynamic> json) {
    return CurrentLiabilities(
      tradePayables: (json['trade_payables'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trade_payables': tradePayables,
    };
  }
}

class OwnerEquity {
  final double retainedEarnings;

  OwnerEquity({required this.retainedEarnings});

  factory OwnerEquity.fromJson(Map<String, dynamic> json) {
    return OwnerEquity(
      retainedEarnings: (json['retained_earnings'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'retained_earnings': retainedEarnings,
    };
  }
}
