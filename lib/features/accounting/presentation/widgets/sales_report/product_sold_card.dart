import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/sales_report/sold_product_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/sales_product_report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ProductSoldCard extends StatelessWidget {
  const ProductSoldCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesProductReportCubit, SalesProductReportState>(
      builder: (context, state) {
        if (state is SalesProductReportLoading) {
          return _buildLoadingShimmer();
        } else if (state is SalesProductReportError) {
          return Center(child: Text(state.message));
        } else if (state is SalesProductReportSuccess) {
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

  Widget _buildProductCard(SoldProductModel product) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.textGrey300,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(product.date),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildCategoryRow(product),
                if (product.subCategories != null) _buildSubCategories(product),
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
        DateFormat('dd MMMM yyyy').format(DateTime.parse(date)),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryRow(SoldProductModel product) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 8),
      Text(
        "Kategori",
        style: AppTextStyle.caption,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product.categoryName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryBackgorund),
              child: Text(
                product.totalItemsSold.toString(),
                style: AppTextStyle.bigCaptionBold
                    .copyWith(color: AppColors.primaryMain),
              )),
        ],
      )
    ]);
  }

  Widget _buildSubCategories(SoldProductModel product) {
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
          Text("Sub Kategori"),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.subCategories!.map((subCategory) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subCategory.subCategoryName,
                      style: AppTextStyle.bigCaptionBold.copyWith(fontSize: 13),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.textGrey300,
                      ),
                      child: Text(
                        subCategory.itemsSold.toString(),
                        style: AppTextStyle.bigCaptionBold.copyWith(
                          fontSize: 13,
                          color: AppColors.textGrey800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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
