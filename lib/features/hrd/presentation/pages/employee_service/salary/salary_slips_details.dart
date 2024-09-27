import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip_detail.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/salary/detail_salary_slip_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/salary/salary_slips_detail_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class SalarySlipDetails extends StatefulWidget {
  final int slipId;
  final String monthName;
  final int year;

  const SalarySlipDetails({
    Key? key,
    required this.slipId,
    required this.monthName,
    required this.year,
  }) : super(key: key);

  @override
  _SalarySlipDetailsState createState() => _SalarySlipDetailsState();
}

class _SalarySlipDetailsState extends State<SalarySlipDetails> {
  @override
  void initState() {
    super.initState();
    _fetchSalarySlipDetail();
  }

  void _fetchSalarySlipDetail() {
    context.read<DetailSalarySlipCubit>().fetchDetailSalarySlip(widget.slipId);
  }

  Future<void> _refreshData() async {
    _fetchSalarySlipDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: Text('${widget.monthName} ${widget.year}', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SalarySlipsDetailContent(slipId: widget.slipId),
        ),
      ),
    );
  }
}
