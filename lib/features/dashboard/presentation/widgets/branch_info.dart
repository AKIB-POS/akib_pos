import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/branch_interaction_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_branches_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/appbar_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class BranchInfo extends StatelessWidget {
  final VoidCallback onTap;

  const BranchInfo({Key? key, required this.onTap}) : super(key: key);
  bool isTabletDevice(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    final aspectRatio = width / height;

    return aspectRatio >= 1.0 && width >= 600;
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = isTabletDevice(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          PreferredSize(
            preferredSize:
                isTablet ? Size.fromHeight(8.h) : Size.fromHeight(10.h),
            child: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 0,
              flexibleSpace: SafeArea(
                child: AppbarDashboardPage(),
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
              decoration: BoxDecoration(
                    color: AppColors.primaryBackgorund,
                    borderRadius: BorderRadius.circular(4),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<BranchInteractionCubit, BranchInteractionState>(
                    builder: (context, state) {
                      return Text(
                        state.branchName.isNotEmpty
                            ? state.branchName
                            : 'Pilih Cabang',
                        style: const TextStyle(
                              color: AppColors.primaryMain,
                              fontWeight: FontWeight.bold,
                            ),
                      );
                    },
                  ),
                  SvgPicture.asset(
                        'assets/icons/ic_branch.svg',
                        height: 20,
                        width: 20,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
