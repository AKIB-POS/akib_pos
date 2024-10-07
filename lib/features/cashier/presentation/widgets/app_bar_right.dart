import 'package:akib_pos/features/cashier/presentation/widgets/transaction/member/member_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/voucher_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class AppBarRight extends StatelessWidget {
  final BuildContext buildContext;
  final String? customerName;
  final String? customerPhone;
  const AppBarRight({super.key, required this.buildContext, this.customerName, this.customerPhone});

  void _showMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MemberDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return VoucherDialog();
                },
              );
            },
            child: SvgPicture.asset(
              "assets/icons/ic_disc.svg",
              height: 3.5.h,
              width: 3.5.w,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                customerName ?? 'Nama Pelanggan',
                style: AppTextStyle.headline5
                    .copyWith(color: AppColors.textGrey800),
              ),
              const SizedBox(height: 0.5),
              Visibility(
                visible: customerPhone == "null" ? false : true,
                child: Text(
                  customerPhone ?? '',
                  style: AppTextStyle.body3
                      .copyWith(color: AppColors.textGrey500),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _showMemberDialog(
                  context); // Panggil fungsi untuk menampilkan MemberDialog
            },
            child: SvgPicture.asset(
              "assets/icons/ic_note.svg",
              height: 3.5.h,
              width: 3.5.w,
            ),
          ),
        ],
      ),
    );
  }
}
