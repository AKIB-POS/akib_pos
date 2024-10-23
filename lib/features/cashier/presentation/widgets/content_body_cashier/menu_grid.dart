import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/models/menu_item_exmpl.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/open_cashier_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/product_dialog.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../../../common/util.dart';

class MenuGrid extends StatelessWidget {
  MenuGrid();

  @override
  Widget build(BuildContext context) {
    final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
    return BlocBuilder<CashierCubit, CashierState>(
      builder: (context, state) {
        final menuItems = context.read<CashierCubit>().filteredItems;

        // Cek apakah status kasir "close"
        if (state.cashRegisterStatus == "close") {
          return _buildClosedCashierView(context);
        }
        if (state.cashRegisterStatus == "open" && _authSharedPref.getCachedCashRegisterId() == null ) {
          return _buildMustOpenCashierView(context);
        }

        if (menuItems.isEmpty) {
          return _buildEmptyMenuView();
        }

        return GridView.builder(
          padding: const EdgeInsets.only(right: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLandscape(context) ? 4 : 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.6,
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

  Widget _buildClosedCashierView(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 8.h,
            ),
            SvgPicture.asset(
              "assets/icons/ic_open_cashier.svg",
              height: 12.h,
              width: 12.h,
            ),
            const SizedBox(height: 16),
            const Text(
              'Kasir Ditutup',
              style: AppTextStyle.headline5,
            ),
            const Text(
              'Silahkan Buka Kasir Untuk Memulai',
              style: AppTextStyle.body3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return OpenCashierDialog();
                    },
                  );
                });
              },
              child: const Text('Buka Kasir'),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMustOpenCashierView(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 8.h,
            ),
            SvgPicture.asset(
              "assets/icons/ic_open_cashier.svg",
              height: 12.h,
              width: 12.h,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Dapat Melakukan Transaksi',
              style: AppTextStyle.headline5,
            ),
            const Text(
              'Perangkat Lain Telah Membuka Kasir Dengan Akun Yang Sama\nTutup Kasir Di Perangkat Tersebut Untuk Dapat Melakkukan Transaksi\nPada Perangkat Ini',
              style: AppTextStyle.body3,
              textAlign: TextAlign.center,
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMenuView() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 15.h),
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
            // Image section
            ExtendedImage.network(
              item.imageUrl != null && item.imageUrl.isNotEmpty
                  ? item.imageUrl
                  : 'assets/images/no_imgproduk.png', // Placeholder URL atau path lokal
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              height: 11.h,
              clearMemoryCacheWhenDispose: true,
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
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    );
                  case LoadState.completed:
                    return null;
                  case LoadState.failed:
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      child: Image.asset(
                        'assets/images/no_imgproduk.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        height: 11.h,
                      ),
                    );
                }
              },
            ),
            // Info section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  item.name,
                  style: AppTextStyle.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1.0),

                // // If there is a discount, show the price with strikethrough effect
                if (item.totalDiscount != null) ...[
                  // Original price with strikethrough
                  Text(
                    Utils.formatCurrency(item.price.toString()),
                    style: AppTextStyle.body3.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey, // Strikethrough color
                    ),
                  ),
                  const SizedBox(height: 2.0),

                //   // Price after discount
                  
                  Text(
                    Utils.formatCurrencyS(
                        (item.price - (item.totalDiscount ?? 0)).toString()),
                    style: AppTextStyle.body3.copyWith(
                      color: Colors.red, // Discounted price color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  // No discount, show normal price
                  Text(
                    Utils.formatCurrency(item.price.toString()),
                    style: AppTextStyle.body3,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
