class PermissionQuotaResponse {
  final String message;
  final PermissionQuotaData data;

  PermissionQuotaResponse({required this.message, required this.data});

  factory PermissionQuotaResponse.fromJson(Map<String, dynamic> json) {
    return PermissionQuotaResponse(
      message: json['message'],
      data: PermissionQuotaData.fromJson(json['data']),
    );
  }
}

class PermissionQuotaData {
  final int totalQuota;
  final int usedQuota;

  PermissionQuotaData({required this.totalQuota, required this.usedQuota});

  factory PermissionQuotaData.fromJson(Map<String, dynamic> json) {
    return PermissionQuotaData(
      totalQuota: json['total_quota'],
      usedQuota: json['used_quota'],
    );
  }
}
