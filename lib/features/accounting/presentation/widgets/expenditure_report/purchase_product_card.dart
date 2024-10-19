import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/expenditure_report/purchased_product_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/purchased_product_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PurchasedProductCard extends StatelessWidget {
  const PurchasedProductCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchasedProductCubit, PurchasedProductState>(
      builder: (context, state) {
        if (state is PurchasedProductLoading) {
          return _buildLoadingShimmer();
        } else if (state is PurchasedProductError) {
           return Utils.buildEmptyState(state.message,
                      "Silahkan Swipe Kebawah\nUntuk Memuat Ulang");
        } else if (state is PurchasedProductSuccess) {
           if(state.products.isEmpty){
            return Utils.buildEmptyStatePlain("Belum ada Data",
            "");
          }
          return Column(
            children: state.products
                .map((product) => _buildProductCard(product))
                .toList(),
          );
        } else {
          return Container(); // Default empty state
        }
      },
    );
  }

  Widget _buildProductCard(PurchasedProductModel product) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.textGrey300,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateHeader(product.date),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildProductRow(product),
                  ],
                ),
              ),
            ],
          ),
          Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.successMain.withOpacity(0.1),
        ),
        child: Text(
          product.expenditureCategory,
          style: AppTextStyle.caption.copyWith(color: AppColors.successMain),
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: AppColors.primaryMain,
      ),
      child: Text(
        DateFormat('dd MMMM yyyy').format(DateTime.parse(date)),
        style: AppTextStyle.caption.copyWith(color: Colors.white)
      ),
    );
  }

  Widget _buildProductRow(PurchasedProductModel product) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        Utils.formatCurrencyDouble(product.amount),
        style: AppTextStyle.headline5
      ),
      const SizedBox(height: 4),
      Text(
        product.productName,
        style: AppTextStyle.headline5,
      ),
    ]);
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.textGrey300),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 50,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
