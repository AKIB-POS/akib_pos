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
      totalAssets: json['total_assets'],
      totalLiabilitiesAndEquity: json['total_liabilities_and_equity'],
    );
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
}

class CurrentAssets {
  final double cash;
  final double inventory;

  CurrentAssets({required this.cash, required this.inventory});

  factory CurrentAssets.fromJson(Map<String, dynamic> json) {
    return CurrentAssets(
      cash: json['cash'],
      inventory: json['inventory'],
    );
  }
}

class FixedAssets {
  final double buildingValue;

  FixedAssets({required this.buildingValue});

  factory FixedAssets.fromJson(Map<String, dynamic> json) {
    return FixedAssets(
      buildingValue: json['building_value'],
    );
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
}

class CurrentLiabilities {
  final double tradePayables;

  CurrentLiabilities({required this.tradePayables});

  factory CurrentLiabilities.fromJson(Map<String, dynamic> json) {
    return CurrentLiabilities(
      tradePayables: json['trade_payables'],
    );
  }
}

class OwnerEquity {
  final double retainedEarnings;

  OwnerEquity({required this.retainedEarnings});

  factory OwnerEquity.fromJson(Map<String, dynamic> json) {
    return OwnerEquity(
      retainedEarnings: json['retained_earnings'],
    );
  }
}
