class CompanyRulesResponse {
  final String companyRules;

  CompanyRulesResponse({required this.companyRules});

  factory CompanyRulesResponse.fromJson(Map<String, dynamic> json) {
    return CompanyRulesResponse(
      companyRules: json['company_rules'],
    );
  }
}

