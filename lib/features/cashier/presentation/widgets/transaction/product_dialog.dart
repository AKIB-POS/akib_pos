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
import 'package:dartz/dartz.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProductDialog extends StatelessWidget {
  final ProductModel product;
  final int? editIndex;

  ProductDialog({required this.product, this.editIndex});

  @override
  Widget build(BuildContext context) {
    if (editIndex != null) {
      final transaction =
          context.read<TransactionCubit>().state.transactions[editIndex!];
      context.read<TransactionCubit>().setInitialStateForEdit(transaction);
    } else {
      context.read<TransactionCubit>().resetState();
    }

    final additions = context.read<CashierCubit>().state.additions;
    final variants = context.read<CashierCubit>().state.variants;
    final tax  = context.read<CashierCubit>().state.taxAmount;
    
    final productAddition = additions.firstWhere(
        (addition) => addition.id == product.additionId,
        orElse: () =>
            AdditionModel(id: 0, additionType: 'None', subAdditions: []));
    final productVariant = variants.firstWhere(
        (variant) => variant.id == product.variantId,
        orElse: () =>
            VariantModel(id: 0, variantType: 'None', subVariants: []));

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        child: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            final currentQuantity = editIndex != null
                ? state.transactions[editIndex!].quantity
                : state.quantity;

            return Column(
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
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Edit Pesanan', style: AppTextStyle.headline6),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            int totalPrice = product.price *
                                context.read<TransactionCubit>().state.quantity;

                            // Add variant prices if any
                            context
                                .read<TransactionCubit>()
                                .state
                                .selectedVariants
                                .forEach((variant) {
                              totalPrice += variant.price *
                                  context
                                      .read<TransactionCubit>()
                                      .state
                                      .quantity;
                            });

                            // Add addition prices if any
                            context
                                .read<TransactionCubit>()
                                .state
                                .selectedAdditions
                                .forEach((addition) {
                              totalPrice += addition.price *
                                  context
                                      .read<TransactionCubit>()
                                      .state
                                      .quantity;
                            });

                            final transaction = TransactionModel(
                              
                              product: product,
                              selectedVariants: context
                                  .read<TransactionCubit>()
                                  .state
                                  .selectedVariants,
                              selectedAdditions: context
                                  .read<TransactionCubit>()
                                  .state
                                  .selectedAdditions,
                              notes:
                                  context.read<TransactionCubit>().state.notes,
                              quantity: context
                                  .read<TransactionCubit>()
                                  .state
                                  .quantity,
                              
                            );

                            if (editIndex != null) {
                              context
                                  .read<TransactionCubit>()
                                  .updateTransaction(editIndex!, transaction);
                            } else {
                              context
                                  .read<TransactionCubit>()
                                  .addTransaction(transaction,tax);
                            }

                            print('Transaction details: $transaction');

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ExtendedImage.network(
                                product.imageUrl,
                                width: 90,
                                height: 90,
                                fit: BoxFit.fill,
                                cache: true,
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name,
                                      style: AppTextStyle.headline6),
                                  const SizedBox(height: 2),
                                  Text(
                                      Utils.formatCurrency(
                                          product.price.toString()),
                                      style: AppTextStyle.body3),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (productVariant.id != 0 || productAddition.id != 0)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (productVariant.id != 0)
                                  Expanded(
                                    flex: productAddition.id != 0 ? 1 : 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...productVariant.subVariants
                                            .map((subVariant) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(subVariant.subVariantType,
                                                  style: AppTextStyle.headline6
                                                      .copyWith(
                                                          color: AppColors
                                                              .primaryMain)),
                                              ...subVariant.options
                                                  .map((option) {
                                                return BlocBuilder<
                                                    TransactionCubit,
                                                    TransactionState>(
                                                  builder: (context, state) {
                                                    // Check if the current option is selected based on both name and subVariantType
                                                    final selected = state
                                                        .selectedVariants
                                                        .any((v) =>
                                                            v.name ==
                                                                option.name &&
                                                            v.subVariantType ==
                                                                subVariant
                                                                    .subVariantType);

                                                    return RadioListTile(
                                                      title: Text(option.name,
                                                          style: AppTextStyle
                                                              .headline6),
                                                      subtitle: Text(
                                                          "+ ${Utils.formatCurrency(option.price.toString())}",
                                                          style: AppTextStyle
                                                              .body3),
                                                      value: option.name,
                                                      groupValue: selected
                                                          ? option.name
                                                          : null,
                                                      dense: true,
                                                      activeColor:
                                                          AppColors.primaryMain,
                                                      toggleable: true,
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      onChanged: (value) {
                                                        if (selected) {
                                                          context
                                                              .read<
                                                                  TransactionCubit>()
                                                              .deselectVariant(SelectedVariant(
                                                                  name: option
                                                                      .name,
                                                                  price: option
                                                                      .price,
                                                                  subVariantType:
                                                                      subVariant
                                                                          .subVariantType));
                                                        } else {
                                                          context
                                                              .read<
                                                                  TransactionCubit>()
                                                              .selectVariant(SelectedVariant(
                                                                  name: option
                                                                      .name,
                                                                  price: option
                                                                      .price,
                                                                  subVariantType:
                                                                      subVariant
                                                                          .subVariantType));
                                                        }
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.zero,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...productAddition.subAdditions
                                            .map((subAddition) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(subAddition.subAdditionType,
                                                  style: AppTextStyle.headline6
                                                      .copyWith(
                                                          color: AppColors
                                                              .primaryMain)),
                                              ...subAddition.options
                                                  .map((option) {
                                                return BlocBuilder<
                                                    TransactionCubit,
                                                    TransactionState>(
                                                  builder: (context, state) {
                                                    final selected = state
                                                        .selectedAdditions
                                                        .any((a) =>
                                                            a.name ==
                                                            option.name);
                                                    return CheckboxListTile(
                                                      title: Text(option.name,
                                                          style: AppTextStyle
                                                              .headline6),
                                                      subtitle: Text(
                                                          "+ ${Utils.formatCurrency(option.price.toString())}",
                                                          style: AppTextStyle
                                                              .body3),
                                                      value: selected,
                                                      dense: true,
                                                      activeColor:
                                                          AppColors.primaryMain,
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      onChanged: (value) {
                                                        if (selected) {
                                                          context
                                                              .read<
                                                                  TransactionCubit>()
                                                              .deselectAddition(
                                                                  SelectedAddition(
                                                                      name: option
                                                                          .name,
                                                                      price: option
                                                                          .price));
                                                        } else {
                                                          context
                                                              .read<
                                                                  TransactionCubit>()
                                                              .selectAddition(
                                                                  SelectedAddition(
                                                                      name: option
                                                                          .name,
                                                                      price: option
                                                                          .price));
                                                        }
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.zero,
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
                              Text('Catatan',
                                  style: AppTextStyle.headline6
                                      .copyWith(color: AppColors.primaryMain)),
                              const SizedBox(height: 8),
                              BlocBuilder<TransactionCubit, TransactionState>(
                                builder: (context, state) {
                                  return TextField(
                                    maxLines: 2,
                                    decoration: const InputDecoration(
                                      fillColor: AppColors.textGrey200,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.textGrey500),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.textGrey500),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryMain),
                                      ),
                                      hintText: 'Masukkan catatan tambahan',
                                    ),
                                    onChanged: (value) {
                                      context
                                          .read<TransactionCubit>()
                                          .updateNotes(value);
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/icons/ic_minus.svg",
                                        height: 38,
                                        width: 38,
                                        color: currentQuantity > 1
                                            ? null
                                            : Colors.grey,
                                      ),
                                      onPressed: currentQuantity > 1
                                          ? () {
                                              if (editIndex != null) {
                                                context
                                                    .read<TransactionCubit>()
                                                    .subtractQuantity(
                                                        editIndex!);
                                              } else {
                                                if (currentQuantity > 1) {
                                                  context
                                                      .read<TransactionCubit>()
                                                      .updateQuantity(
                                                          currentQuantity - 1);
                                                }
                                              }
                                            }
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(currentQuantity.toString(),
                                        style: AppTextStyle.headline6),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/icons/ic_plus.svg",
                                        height: 38,
                                        width: 38,
                                      ),
                                      onPressed: () {
                                        if (editIndex != null) {
                                          context
                                              .read<TransactionCubit>()
                                              .addQuantity(editIndex!);
                                        } else {
                                          context
                                              .read<TransactionCubit>()
                                              .updateQuantity(
                                                  currentQuantity + 1);
                                        }
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
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll<Color>(
                          AppColors.primaryMain),
                      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      int totalPrice = product.price *
                          context.read<TransactionCubit>().state.quantity;

                      // Add variant prices if any
                      context
                          .read<TransactionCubit>()
                          .state
                          .selectedVariants
                          .forEach((variant) {
                        totalPrice += variant.price *
                            context.read<TransactionCubit>().state.quantity;
                      });
                      print("pajaknya ${tax}");
                      // Add addition prices if any
                      context
                          .read<TransactionCubit>()
                          .state
                          .selectedAdditions
                          .forEach((addition) {
                        totalPrice += addition.price *
                            context.read<TransactionCubit>().state.quantity;
                      });

                      final transaction = TransactionModel(
                        product: product,
                        selectedVariants: context
                            .read<TransactionCubit>()
                            .state
                            .selectedVariants,
                        selectedAdditions: context
                            .read<TransactionCubit>()
                            .state
                            .selectedAdditions,
                        notes: context.read<TransactionCubit>().state.notes,
                        quantity:
                            context.read<TransactionCubit>().state.quantity,
                      );

                      if (editIndex != null) {
                        context
                            .read<TransactionCubit>()
                            .updateTransaction(editIndex!, transaction);
                      } else {
                        context
                            .read<TransactionCubit>()
                            .addTransaction(transaction,tax);
                      }

                      print('Transaction details: $transaction');

                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
