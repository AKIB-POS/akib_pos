// models/attendance_recap.dart
class AttendanceRecap {
  final String workDuration;
  final LeaveBalance leaveBalance;
  final List<Permission> permissions;
  final String alpha;
  final String overtimeDuration;

  AttendanceRecap({
    required this.workDuration,
    required this.leaveBalance,
    required this.permissions,
    required this.alpha,
    required this.overtimeDuration,
  });

  factory AttendanceRecap.fromJson(Map<String, dynamic> json) {
    return AttendanceRecap(
      workDuration: json['work_duration'],
      leaveBalance: LeaveBalance.fromJson(json['leave_balance']),
      permissions: (json['permissions'] as List)
          .map((p) => Permission.fromJson(p))
          .toList(),
      alpha: json['alpha'],
      overtimeDuration: json['overtime_duration'],
    );
  }
}

class LeaveBalance {
  final String totalLeave;
  final List<LeaveDetail> details;

  LeaveBalance({
    required this.totalLeave,
    required this.details,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      totalLeave: json['total_leave'],
      details: (json['details'] as List)
          .map((d) => LeaveDetail.fromJson(d))
          .toList(),
    );
  }
}

class LeaveDetail {
  final String leaveType;
  final String days;

  LeaveDetail({
    required this.leaveType,
    required this.days,
  });

  factory LeaveDetail.fromJson(Map<String, dynamic> json) {
    return LeaveDetail(
      leaveType: json['leave_type'],
      days: json['days'],
    );
  }
}

class Permission {
  final String permissionType;
  final String duration;

  Permission({
    required this.permissionType,
    required this.duration,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      permissionType: json['permission_type'],
      duration: json['duration'],
    );
  }
}
