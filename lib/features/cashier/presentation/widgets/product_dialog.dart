import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/addition_option.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/varian_option.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
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
    context.read<TransactionCubit>().resetState();

    final additions = context.read<CashierCubit>().state.additions;
    final variants = context.read<CashierCubit>().state.variants;
    final productAddition = additions.firstWhere(
        (addition) => addition.id == product.additionId,
        orElse: () => AdditionModel(id: 0, additionType: 'None', subAdditions: []));
    final productVariant = variants.firstWhere(
        (variant) => variant.id == product.variantId,
        orElse: () => VariantModel(id: 0, variantType: 'None', subVariants: []));

    return Builder(
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8, // Adjust height if necessary
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
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
                                                  return BlocBuilder<TransactionCubit, TransactionState>(
                                                    builder: (context, state) {
                                                      return RadioListTile(
                                                        title: Text(option.name, style: AppTextStyle.headline6),
                                                        subtitle: Text(option.price.toString(), style: AppTextStyle.body3),
                                                        value: option.name,
                                                        groupValue: state.selectedVariants[subVariant.subVariantType],
                                                        dense: true,
                                                        visualDensity: VisualDensity.compact,
                                                        onChanged: (value) {
                                                          context.read<TransactionCubit>().selectVariant(subVariant.subVariantType, value.toString());
                                                        },
                                                        contentPadding: EdgeInsets.zero, // Ensuring no extra padding
                                                      );
                                                    },
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
                                                  return BlocBuilder<TransactionCubit, TransactionState>(
                                                    builder: (context, state) {
                                                      return CheckboxListTile(
                                                        title: Text(option.name, style: AppTextStyle.headline6),
                                                        subtitle: Text(option.price.toString(), style: AppTextStyle.body3),
                                                        value: state.selectedAdditions[subAddition.subAdditionType]?.contains(option.name) ?? false,
                                                        dense: true,
                                                        visualDensity: VisualDensity.compact,
                                                        onChanged: (value) {
                                                          context.read<TransactionCubit>().selectAddition(subAddition.subAdditionType, option.name);
                                                        },
                                                        contentPadding: EdgeInsets.zero, // Ensuring no extra padding
                                                      );
                                                    },
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
                                BlocBuilder<TransactionCubit, TransactionState>(
                                  builder: (context, state) {
                                    return TextField(
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
                                      onChanged: (value) {
                                        context.read<TransactionCubit>().updateNotes(value);
                                      },
                                    );
                                  },
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
                                        onPressed: () {
                                          context.read<TransactionCubit>().updateQuantity(
                                                (context.read<TransactionCubit>().state.quantity - 1).clamp(1, 100),
                                              );
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      BlocBuilder<TransactionCubit, TransactionState>(
                                        builder: (context, state) {
                                          return Text(state.quantity.toString(), style: AppTextStyle.headline6);
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          "assets/icons/ic_plus.svg", // Replace with your icon asset
                                          height: 38,
                                          width: 38,
                                        ),
                                        onPressed: () {
                                          context.read<TransactionCubit>().updateQuantity(
                                                (context.read<TransactionCubit>().state.quantity + 1).clamp(1, 100),
                                              );
                                        },
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
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
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
                    int totalPrice = product.price * context.read<TransactionCubit>().state.quantity;

                    // Add variant prices if any
                    context.read<TransactionCubit>().state.selectedVariants.forEach((variantType, variantName) {
                      final subVariant = productVariant.subVariants.firstWhere(
                          (v) => v.subVariantType == variantType, orElse: () => SubVariantModel(id: 0, subVariantType: '', options: []));
                      if (subVariant.subVariantType.isNotEmpty) {
                        final option = subVariant.options.firstWhere((o) => o.name == variantName, orElse: () => VariantOption(name: '', price: 0));
                        if (option.name.isNotEmpty) {
                          totalPrice += option.price * context.read<TransactionCubit>().state.quantity;
                        }
                      }
                    });

                    // Add addition prices if any
                    context.read<TransactionCubit>().state.selectedAdditions.forEach((additionType, additionNames) {
                      final subAddition = productAddition.subAdditions.firstWhere(
                          (a) => a.subAdditionType == additionType, orElse: () => SubAdditionModel(id: 0, subAdditionType: '', options: []));
                      if (subAddition.subAdditionType.isNotEmpty) {
                        additionNames.forEach((additionName) {
                          final option = subAddition.options.firstWhere((o) => o.name == additionName, orElse: () => AdditionOption(name: '', price: 0));
                          if (option.name.isNotEmpty) {
                            totalPrice += option.price * context.read<TransactionCubit>().state.quantity;
                          }
                        });
                      }
                    });

                    final transaction = TransactionModel(
                      product: product.copyWith(price: totalPrice),
                      selectedVariants: context.read<TransactionCubit>().state.selectedVariants,
                      selectedAdditions: context.read<TransactionCubit>().state.selectedAdditions,
                      notes: context.read<TransactionCubit>().state.notes,
                      quantity: context.read<TransactionCubit>().state.quantity,
                    );

                    context.read<TransactionCubit>().addTransaction(transaction);

                    print('Transaction details: $transaction');

                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
