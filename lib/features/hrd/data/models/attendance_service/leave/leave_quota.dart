class LeaveQuotaResponse {
  final String message;
  final LeaveQuotaData data;

  LeaveQuotaResponse({required this.message, required this.data});

  factory LeaveQuotaResponse.fromJson(Map<String, dynamic> json) {
    return LeaveQuotaResponse(
      message: json['message'],
      data: LeaveQuotaData.fromJson(json['data']),
    );
  }
}

class LeaveQuotaData {
  final int totalQuota;
  final int usedQuota;

  LeaveQuotaData({required this.totalQuota, required this.usedQuota});

  factory LeaveQuotaData.fromJson(Map<String, dynamic> json) {
    return LeaveQuotaData(
      totalQuota: json['total_quota'],
      usedQuota: json['used_quota'],
    );
  }
}
