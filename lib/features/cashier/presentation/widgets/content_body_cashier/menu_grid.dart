import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/data/models/menu_item_exmpl.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/product_dialog.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class MenuGrid extends StatelessWidget {
  MenuGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierCubit, CashierState>(
      builder: (context, state) {
        final menuItems = context.read<CashierCubit>().filteredItems;

        if (menuItems.isEmpty) {
          return Container(
            alignment: Alignment.center, // Center the content in the container
            padding:  EdgeInsets.only(bottom: 15.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 8.h,
                ),
                SvgPicture.asset(
                  "assets/images/empty_product.svg",
                  height: 12.h,
                  width: 12.h,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Belum Ada Produk',
                  style: AppTextStyle.headline5,
                ),
                const Text(
                  'Tambah produk terlebih dahulu untuk\nbisa mengatur sesuai kebutuhan',
                  style: AppTextStyle.body3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.only(right: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final product = menuItems[index];
            return GestureDetector(
              onTap: () => _showProductDialog(context, product),
              child: MenuCard(item: product),
            );
          },
        );
      },
    );
  }

  void _showProductDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductDialog(product: product);
      },
    );
  }
}

class MenuCard extends StatelessWidget {
  final ProductModel item;

  MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.imageUrl == '' || item.imageUrl!.isEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: Image.asset(
                      'assets/images/no_imgproduk.png',
                      width: double.infinity,
                      fit: BoxFit.fill,
                      height: 11.h,
                    ),
                  )
                : ExtendedImage.network(
                    item.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    height: 11.h,
                    cache: true,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 11.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                              ),
                            ),
                          );
                        case LoadState.completed:
                          return null;
                        case LoadState.failed:
                          return ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            child: Image.asset(
                              'assets/images/no_imgproduk.png',
                              width: 90,
                              height: 90,
                              fit: BoxFit.fill,
                            ),
                          );
                      }
                    },
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyle.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1.0),
                Text(
                  Utils.formatCurrency(item.price.toString()),
                  style: AppTextStyle.body3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
