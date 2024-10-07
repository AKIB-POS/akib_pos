class LeaveQuotaResponse {
  final String message;
  final LeaveQuotaData data;

  LeaveQuotaResponse({required this.message, required this.data});

  factory LeaveQuotaResponse.fromJson(Map<String, dynamic> json) {
    return LeaveQuotaResponse(
      message: json['message'] ?? '',
      data: LeaveQuotaData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class LeaveQuotaData {
  final int totalQuota;
  final int usedQuota;

  LeaveQuotaData({required this.totalQuota, required this.usedQuota});

  factory LeaveQuotaData.fromJson(Map<String, dynamic> json) {
    return LeaveQuotaData(
      totalQuota: (json['total_quota'] as num?)?.toInt() ?? 0,
      usedQuota: (json['used_quota'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_quota': totalQuota,
      'used_quota': usedQuota,
    };
  }
}
