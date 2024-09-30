import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalarySlip {
  final int slipId;
  final String monthName;

  SalarySlip({required this.slipId, required this.monthName});

  factory SalarySlip.fromJson(Map<String, dynamic> json) {
    return SalarySlip(
      slipId: json['slip_id'],
      monthName: json['month_name'],
    );
  }
}

class SalarySlipsResponse {
  final List<SalarySlip> salarySlips;

  SalarySlipsResponse({required this.salarySlips});

  factory SalarySlipsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<SalarySlip> salarySlipList =
        list.map((i) => SalarySlip.fromJson(i)).toList();
    return SalarySlipsResponse(salarySlips: salarySlipList);
  }
}
