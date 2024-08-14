import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/voucher_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';

class AppBarContent extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appBarLeft(_controller, context, _focusNode),
          appBarRight(context),
        ],
      ),
    );
  }

  Expanded appBarRight(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
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
                Text('Nama Pelanggan',
                    style: AppTextStyle.headline5
                        .copyWith(color: AppColors.textGrey800)),
                const SizedBox(height: 0.5),
                Text('No. Order: 0001',
                    style: AppTextStyle.body3
                        .copyWith(color: AppColors.textGrey500)),
              ],
            ),
            SvgPicture.asset(
              "assets/icons/ic_note.svg",
              height: 3.5.h,
              width: 3.5.w,
            ),
          ],
        ),
      ),
    );
  }

  Expanded appBarLeft(TextEditingController controller, BuildContext context, FocusNode focusNode) {
    return Expanded(
      flex: 5,
      child: Container(
        color: AppColors.backgroundGrey,
        margin: const EdgeInsets.only(top: 20, left: 8),
        child: Row(
          children: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/ic_burger_menu.svg",
                    height: 6.w,
                    width: 6.h,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Cafe Arrazzaq', style: AppTextStyle.headline6),
                const Text('Fadhil Muhaimin', style: AppTextStyle.body3),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                child: Center(
                  child: FocusScope(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        // Do something when TextField loses focus if needed
                      }
                    },
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Cari Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8.0,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            _performSearch(context, controller.text);
                          },
                        ),
                      ),
                      onSubmitted: (text) {
                        _performSearch(context, text);
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Container(
              height: 50.0,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/ic_save.svg",
                ),
              ),
            ),
            const SizedBox(width: 2),
          ],
        ),
      ),
    );
  }

  void _performSearch(BuildContext context, String text) {
    BlocProvider.of<CashierCubit>(context).updateSearchText(text);
    _focusNode.unfocus();
  }
}
