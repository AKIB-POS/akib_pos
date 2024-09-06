import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/purchasing_item_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/purchase_list_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PurchaseListCard extends StatelessWidget {
  const PurchaseListCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseListCubit, PurchaseListState>(
      builder: (context, state) {
        if (state is PurchaseListLoading) {
          return _buildLoadingShimmer();
        } else if (state is PurchaseListError) {
          return Center(child: Text(state.message));
        } else if (state is PurchaseListSuccess) {
          return Column(
            children: state.purchases
                .map((purchase) => _buildPurchaseCard(purchase))
                .toList(),
          );
        } else {
          return Container(); // Default empty state
        }
      },
    );
  }

  Widget _buildPurchaseCard(PurchaseItemModel purchase) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.textGrey300,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(purchase.date),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildVendorRow(purchase),
                const SizedBox(height: 8),
                _buildProductDetails(purchase),
              ],
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
        date,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVendorRow(PurchaseItemModel purchase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          purchase.vendorName,
          style: AppTextStyle.caption,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              purchase.productName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryBackgorund),
                child: Text(
                  "${purchase.quantity}/${purchase.unit}",
                  style: AppTextStyle.bigCaptionBold
                      .copyWith(color: AppColors.primaryMain),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildProductDetails(PurchaseItemModel purchase) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.backgroundGrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kode Produk",
                style: AppTextStyle.bigCaptionBold.copyWith(fontSize: 13),
              ),
              Text(
                purchase.productCode,
                style: AppTextStyle.bigCaptionBold.copyWith(
                fontSize: 13,
                color: AppColors.textGrey800,
              ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Nilai",
                style: AppTextStyle.bigCaptionBold.copyWith(fontSize: 13),
              ),
              Text(
                Utils.formatCurrencyDouble(purchase.totalValue),
                style: AppTextStyle.bigCaptionBold.copyWith(
                  fontSize: 13,
                  color: AppColors.textGrey800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
