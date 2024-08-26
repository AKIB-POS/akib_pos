import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class ProductDialog extends StatefulWidget {
  final ProductModel product;
  final int? editIndex;

  ProductDialog({required this.product, this.editIndex});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();

    if (widget.editIndex != null) {
      final transaction = context
          .read<TransactionCubit>()
          .state
          .transactions[widget.editIndex!];
      context.read<TransactionCubit>().setInitialStateForEdit(transaction);
      print("apakahh di init ${transaction.quantity}");
      notesController.text = transaction.notes;
    } else {
      context.read<TransactionCubit>().resetState();
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final additions = context.read<CashierCubit>().state.additions;
    final variants = context.read<CashierCubit>().state.variants;
    final tax = context.read<CashierCubit>().state.taxAmount;

    final productAddition = additions.firstWhere(
        (addition) => addition.id == widget.product.additionId,
        orElse: () =>
            AdditionModel(id: 0, additionType: 'None', subAdditions: []));
    final productVariant = variants.firstWhere(
        (variant) => variant.id == widget.product.variantId,
        orElse: () =>
            VariantModel(id: 0, variantType: 'None', subVariants: []));

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        child: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            final currentQuantity = widget.editIndex != null
                ? state.transactions[widget.editIndex!].quantity
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
                            print("apakahh submit atas ${currentQuantity}");
                            final transactionCubit =
                                context.read<TransactionCubit>();

                            // Ambil state terbaru dari cubit
                            final currentState = state;
                            print("berapakahh $currentState");

                            // Hitung total harga berdasarkan kuantitas terbaru dan varian serta tambahan yang dipilih
                            int totalPrice =
                                widget.product.price * currentQuantity;

                            currentState.selectedVariants.forEach((variant) {
                              totalPrice += variant.price * currentQuantity;
                            });

                            currentState.selectedAdditions.forEach((addition) {
                              totalPrice += addition.price * currentQuantity;
                            });

                            // Buat model transaksi berdasarkan state terbaru
                            final transaction = TransactionModel(
                              product: widget.product,
                              selectedVariants: currentState.selectedVariants,
                              selectedAdditions: currentState.selectedAdditions,
                              notes: notesController.text,
                              quantity: currentState
                                  .quantity, // Pastikan kuantitas diperbarui
                            );

                            if (widget.editIndex != null) {
                              // Update transaksi jika mengedit
                              transactionCubit.updateTransaction(
                                  widget.editIndex!, transaction);
                            } else {
                              // Tambahkan transaksi baru jika tidak mengedit
                              // transactionCubit.addTransaction(transaction, tax);
                            }

                            print('Transaction details: $transaction');

                            // Tutup dialog
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
                          widget.product.imageUrl == '' ||
                                  widget.product.imageUrl!.isEmpty
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  child: Image.asset(
                                    'assets/images/no_imgproduk.png', // Gambar default jika URL null atau kosong
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : ExtendedImage.network(
                                  widget.product.imageUrl!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.fill,
                                  cache: true,
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  loadStateChanged: (ExtendedImageState state) {
                                    switch (state.extendedImageLoadState) {
                                      case LoadState.loading:
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8.0)),
                                            ),
                                          ),
                                        );
                                      case LoadState.completed:
                                        return null; // Menampilkan gambar asli jika berhasil
                                      case LoadState.failed:
                                        return ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8.0)),
                                          child: Image.asset(
                                            'assets/images/no_imgproduk.png', // Gambar default jika URL gagal dimuat
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                    }
                                  },
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
                                                      value: option.id,
                                                      groupValue: selected
                                                          ? option.id
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
                                                                  id: option.id,
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
                                                                  id: option.id,
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
                                              Text(
                                                  subAddition.subAdditionType ??
                                                      "",
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
                                                                      id: option
                                                                          .id,
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
                                                                      id:
                                                                          option
                                                                              .id,
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
                              TextField(
                                controller: notesController,
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
                                              if (widget.editIndex != null) {
                                                context
                                                    .read<TransactionCubit>()
                                                    .subtractQuantity(
                                                        widget.editIndex!);
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
                                        if (widget.editIndex != null) {
                                          context
                                              .read<TransactionCubit>()
                                              .addQuantity(widget.editIndex!);
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
                      final transactionCubit = context.read<TransactionCubit>();

                      // Ambil state terbaru dari cubit
                      final currentState = transactionCubit.state;

                      print("apakahh di product dialog  ${currentQuantity}");

                      // Hitung total harga berdasarkan kuantitas terbaru dan varian serta tambahan yang dipilih
                      int totalPrice = widget.product.price * currentQuantity;

                      currentState.selectedVariants.forEach((variant) {
                        totalPrice += variant.price * currentQuantity;
                      });

                      currentState.selectedAdditions.forEach((addition) {
                        totalPrice += addition.price * currentQuantity;
                      });
                      print("apakahh sebelum ${currentQuantity}");
                      // Buat model transaksi berdasarkan state terbaru
                      final transaction = TransactionModel(
                        product: widget.product,
                        selectedVariants: currentState.selectedVariants,
                        selectedAdditions: currentState.selectedAdditions,
                        notes: notesController.text,
                        quantity: currentQuantity,
                      );

                      if (widget.editIndex != null) {
                        // Update transaksi jika mengedit
                        transactionCubit.updateTransaction(
                            widget.editIndex!, transaction);
                        print("apakahh di update $transaction");
                      } else {
                        // Tambahkan transaksi baru jika tidak mengedit
                        transactionCubit.addTransaction(transaction, tax);
                      }

                      print('Transaction details: $transaction');

                      // Tutup dialog
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
