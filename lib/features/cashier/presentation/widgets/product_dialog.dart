import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProductDialog extends StatelessWidget {
  final ProductModel product;

  ProductDialog({required this.product});

  @override
  Widget build(BuildContext context) {
    final additions = context.read<CashierCubit>().state.additions;
    final variants = context.read<CashierCubit>().state.variants;
    final productAddition = additions.firstWhere(
        (addition) => addition.id == product.additionId,
        orElse: () => AdditionModel(id: 0, additionType: 'None', subAdditions: []));
    final productVariant = variants.firstWhere(
        (variant) => variant.id == product.variantId,
        orElse: () => VariantModel(id: 0, variantType: 'None', subVariants: []));

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 70), // Space for the header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center the items vertically
                    children: [
                      ExtendedImage.network(
                        product.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.fill,
                        cache: true,
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: AppTextStyle.headline6),
                          const SizedBox(height: 2),
                          Text(Utils.formatCurrency(product.price.toString()), style: AppTextStyle.body3),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (productVariant.id != 0 || productAddition.id != 0)
                    Row(
                      children: [
                        if (productVariant.id != 0)
                          Expanded(
                            flex: productAddition.id != 0 ? 1 : 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...productVariant.subVariants.map((subVariant) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(subVariant.subVariantType, style: AppTextStyle.headline6.copyWith(color: AppColors.primaryMain)),
                                      ...subVariant.options.map((option) {
                                        return RadioListTile(
                                          title: Text(option.name, style: AppTextStyle.headline6),
                                          subtitle: Text(option.price.toString(), style: AppTextStyle.body3),
                                          value: option.name,
                                          groupValue: null,
                                          dense: true,
                                          visualDensity: VisualDensity.compact,
                                          onChanged: (value) {},
                                          contentPadding: EdgeInsets.zero, // Ensuring no extra padding
                                        );
                                      }).toList(),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        if (productAddition.id != 0)
                          Expanded(
                            flex: productVariant.id != 0 ? 1 : 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...productAddition.subAdditions.map((subAddition) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(subAddition.subAdditionType, style: AppTextStyle.headline6.copyWith(color: AppColors.primaryMain)),
                                      ...subAddition.options.map((option) {
                                        return CheckboxListTile(
                                          title: Text(option.name, style: AppTextStyle.headline6),
                                          subtitle: Text(option.price.toString(), style: AppTextStyle.body3),
                                          value: false,
                                          dense: true,
                                          visualDensity: VisualDensity.compact,
                                          onChanged: (value) {},
                                          contentPadding: EdgeInsets.zero, // Ensuring no extra padding
                                        );
                                      }).toList(),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catatan', style: AppTextStyle.headline6.copyWith(color: AppColors.primaryMain)),
                      const SizedBox(height: 8),
                      const TextField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          fillColor: AppColors.textGrey200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textGrey500), // Ubah warna border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textGrey500), // Warna border saat enabled
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primaryMain), // Warna border saat focused
                          ),
                          hintText: 'Masukkan catatan tambahan',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                "assets/icons/ic_minus.svg", // Replace with your icon asset
                                height: 38,
                                width: 38,
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 16),
                            Text('1', style: AppTextStyle.headline6),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: SvgPicture.asset(
                                "assets/icons/ic_plus.svg", // Replace with your icon asset
                                height: 38,
                                width: 38,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Pesanan', style: AppTextStyle.headline6),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity, // Full width
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryMain), // Background color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(vertical: 16), // Vertical padding
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Border radius
                    ),
                  ),
                ),
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
