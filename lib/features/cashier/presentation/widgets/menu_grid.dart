import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/data/models/menu_item_exmpl.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_image/extended_image.dart';

class MenuGrid extends StatelessWidget {
  MenuGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierCubit, CashierState>(
      builder: (context, state) {
        final menuItems = context.read<CashierCubit>().filteredItems;
        return GridView.builder(
          padding: const EdgeInsets.only(right: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Update to 4 columns
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
            ExtendedImage.network(
              item.imageUrl,
              width: double.infinity,
              height: 120,
              fit: BoxFit.fill,
              cache: true,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                  item.price.toString(),
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