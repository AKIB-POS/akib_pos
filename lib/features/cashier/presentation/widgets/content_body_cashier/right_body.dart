import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/util.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/save_transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/process_transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/app_bar_right.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/printer_management_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/confirm_remove_transaction_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/payment_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/product_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/save_transaction_dialog.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class RightBody extends StatelessWidget {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  RightBody({super.key});
  @override
  Widget build(BuildContext context) {
    final customerName =
        context.select((TransactionCubit cubit) => cubit.state.customerName);
    final customerPhone = context.select(
        (TransactionCubit cubit) => cubit.state.customerPhone); // Add this line

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!isLandscape(context))
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 12),
              height: 2,
              color: AppColors.textGrey800.withOpacity(0.1),
            ),
          if (!isLandscape(context))
            AppBarRight(
              buildContext: context,
              customerPhone: customerPhone,
              customerName: customerName,
            ),
          Expanded(
            child: BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, state) {
                if (state.transactions.isEmpty) {
                  return SingleChildScrollView(
                    child: Container(
                      alignment: Alignment
                          .center, // Center the content in the container
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 8.h,
                          ),
                          SvgPicture.asset(
                            "assets/images/empty_cart.svg",
                            height: 12.h,
                            width: 12.h,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada transaksi',
                            style: AppTextStyle.headline6,
                          ),
                          const Text(
                            'Silahkan tambahkan produk ke keranjang\nmelalui katalog yang ada',
                            style: AppTextStyle.body3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: BlocBuilder<TransactionCubit, TransactionState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                _buildOptionButton(
                                  context,
                                  label: 'Dine In',
                                  value: 'dine_in',
                                  selected: state.orderType == 'dine_in',
                                ),
                                const SizedBox(width: 8),
                                _buildOptionButton(
                                  context,
                                  label: 'Take Away',
                                  value: 'takeaway',
                                  selected: state.orderType == 'take_away',
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = state.transactions[index];
                          print("apakahh di right body ${transaction}");
                          return Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        transaction.product.imageUrl == '' ||
                                                transaction
                                                    .product.imageUrl!.isEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8.0)),
                                                child: Image.asset(
                                                  'assets/images/no_imgproduk.png', // Gambar default jika URL null atau kosong
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : ExtendedImage.network(
                                                transaction.product.imageUrl!,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill,
                                                cache: true,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8.0)),
                                                loadStateChanged:
                                                    (ExtendedImageState state) {
                                                  switch (state
                                                      .extendedImageLoadState) {
                                                    case LoadState.loading:
                                                      return Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          width: 80,
                                                          height: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[300],
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        8.0)),
                                                          ),
                                                        ),
                                                      );
                                                    case LoadState.completed:
                                                      return null; // Menampilkan gambar asli jika berhasil
                                                    case LoadState.failed:
                                                      return ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        child: Image.asset(
                                                          'assets/images/no_imgproduk.png', // Gambar default jika URL gagal dimuat
                                                          width: 80,
                                                          height: 80,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundGrey,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ProductDialog(
                                                    product:
                                                        transaction.product,
                                                    editIndex: index,
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Edit',
                                                    style: AppTextStyle
                                                        .subtitle2
                                                        .copyWith(
                                                            color: AppColors
                                                                .primaryMain)),
                                                const SizedBox(width: 4),
                                                const Icon(
                                                  Icons.edit,
                                                  color: AppColors.primaryMain,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(transaction.product.name,
                                              style: AppTextStyle.headline6),
                                          const SizedBox(height: 2),
                                          if (transaction
                                                  .product.totalDiscount !=
                                              null) ...[
                                            Text(
                                              Utils.formatCurrency(transaction
                                                  .product.totalPrice
                                                  .toString()),
                                              style:
                                                  AppTextStyle.body3.copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors
                                                    .grey, // Strikethrough color
                                              ),
                                            ),
                                            const SizedBox(height: 2.0),

                                            //   // Price after discount

                                            Text(
                                              Utils.formatCurrencyDouble(
                                                  (transaction.product
                                                              .totalPrice
                                                              ?.toDouble() ??
                                                          0) -
                                                      (transaction.product
                                                              .totalPriceDisc
                                                              ?.toDouble() ??
                                                          0)),
                                              style:
                                                  AppTextStyle.body3.copyWith(
                                                color: Colors
                                                    .red, // Discounted price color
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            //     Text(
                                            //   Utils.formatCurrency(transaction
                                            //       .product.totalPrice
                                            //       .toString()),
                                            //   style: AppTextStyle.body3),
                                            // Text(
                                            //     Utils.formatCurrencyDouble(
                                            //         transaction.product
                                            //                 .totalDiscount ??
                                            //             0),
                                            //    style: AppTextStyle.body3),
                                          ] else ...[
                                            Text(
                                                Utils.formatCurrency(transaction
                                                    .product.totalPrice
                                                    .toString()),
                                                style: AppTextStyle.body3),
                                          ],
                                          const SizedBox(height: 8),
                                          Text('Catatan: ${transaction.notes}',
                                              style: AppTextStyle.body3),
                                          const SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Variants: ${transaction.selectedVariants.map((v) => v.name).join(', ')}',
                                                style: AppTextStyle.body3,
                                              ),
                                              Text(
                                                'Additions: ${transaction.selectedAdditions.map((a) => a.name).join(', ')}',
                                                style: AppTextStyle.body3,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: SvgPicture.asset(
                                                "assets/icons/ic_minus.svg",
                                                height: 28,
                                                width: 28,
                                              ),
                                              onPressed: () async {
                                                // Cek apakah quantity saat ini adalah 1
                                                if (transaction.quantity == 1 &&
                                                    state.transactions.length ==
                                                        1) {
                                                  // Tampilkan dialog konfirmasi
                                                  final bool? confirmDelete =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return const ConfirmRemoveTransactionDialog();
                                                    },
                                                  );

                                                  // Jika pengguna menekan "Ya, Hapus", lanjutkan pengurangan quantity
                                                  if (confirmDelete == true) {
                                                    context
                                                        .read<
                                                            TransactionCubit>()
                                                        .subtractQuantity(
                                                            index);
                                                  }
                                                } else {
                                                  // Jika quantity lebih dari 1, langsung kurangi quantity
                                                  context
                                                      .read<TransactionCubit>()
                                                      .subtractQuantity(index);
                                                }
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                                transaction.quantity.toString(),
                                                style: AppTextStyle.headline6),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: SvgPicture.asset(
                                                "assets/icons/ic_plus.svg",
                                                height: 28,
                                                width: 28,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<TransactionCubit>()
                                                    .addQuantity(index);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  color: Colors.grey.withOpacity(0.5),
                                  height: 1,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          BlocBuilder<ProcessTransactionCubit, ProcessTransactionState>(
            builder: (context, processState) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(
                    left: 16, right: 12, top: 0, bottom: 2),
                child: AnimatedCrossFade(
                  firstChild: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                  ),
                  secondChild: BlocBuilder<TransactionCubit, TransactionState>(
                    builder: (context, state) {
                      return Visibility(
                        visible: processState.isDetailsVisible,
                        child: Container(
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.textGrey300.withOpacity(0.8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal',
                                      style: AppTextStyle.body3),
                                  Text(
                                      Utils.formatCurrencyDouble(
                                          _calculateSubtotal(state)),
                                      style: AppTextStyle.body3),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Diskon Produk',
                                      style: AppTextStyle.body3),
                                  Text("${Utils.formatCurrencyDouble(
                                          _calculateSubtotalDisc(state))}"
                                      ,
                                      style: AppTextStyle.body3),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Diskon',
                                      style: AppTextStyle.body3),
                                  Text(
                                      "-${Utils.formatCurrencyDouble(_calculateDiscount(context.read<TransactionCubit>().state))}",
                                      style: AppTextStyle.body3),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Pajak(PPN) (${state.tax}%)',
                                      style: AppTextStyle.body3),
                                  Text(
                                      "${Utils.formatCurrencyDouble(_getTax(state))}",
                                      style: AppTextStyle.body3),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  crossFadeState: processState.isDetailsVisible
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
          ),
          BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              final isEmpty =
                  state.transactions.isEmpty || state.orderType.isEmpty;
              return Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<ProcessTransactionCubit>()
                            .toggleDetailsVisibility();
                      },
                      child: Row(
                        children: [
                          Text(
                            'Total (${context.read<TransactionCubit>().state.transactions.length})',
                            style: AppTextStyle.headline6,
                          ),
                          const SizedBox(width: 2),
                          BlocBuilder<ProcessTransactionCubit,
                              ProcessTransactionState>(
                            builder: (context, state) {
                              return Icon(
                                state.isDetailsVisible
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                color: Colors.black,
                              );
                            },
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                Utils.formatCurrencyDouble(_calculateTotal(
                                    context.read<TransactionCubit>().state)),
                                style: AppTextStyle.headline6,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: isEmpty
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed: isEmpty
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SaveTransactionDialog(
                                          onSave: (notes) async {
                                            List<TransactionModel>
                                                transactions = context
                                                    .read<TransactionCubit>()
                                                    .state
                                                    .transactions;
                                            double disc = context
                                                .read<TransactionCubit>()
                                                .state
                                                .discount;
                                            String? name = context
                                                .read<TransactionCubit>()
                                                .state
                                                .customerName;
                                            String? telp = context
                                                .read<TransactionCubit>()
                                                .state
                                                .customerPhone;
                                            int? id = context
                                                .read<TransactionCubit>()
                                                .state
                                                .customerId;

                                            await context
                                                .read<TransactionCubit>()
                                                .saveFullTransaction(
                                                    transactions,
                                                    notes,
                                                    disc,
                                                    name,
                                                    telp,
                                                    id);
                                            context
                                                .read<BadgeCubit>()
                                                .updateBadgeCount();
                                          },
                                        );
                                      },
                                    );
                                  },
                            child: Text(
                              'Simpan',
                              style: AppTextStyle.headline5.copyWith(
                                color: isEmpty
                                    ? Colors.grey
                                    : AppColors.primaryMain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: ElevatedButton(
                            onPressed: isEmpty
                                ? null
                                : () {
                                    // Show the PaymentDialog
                                    final fullTransaction =
                                        FullTransactionModel(
                                      transactions: state.transactions,
                                      discount: state.discount,
                                      tax: _getTax(state),
                                      voucher: state.voucher,
                                      customerId: state.customerId,
                                      customerName: state.customerName,
                                      totalDiscountProduct: _calculateSubtotalDisc(state),
                                      customerPhone: state.customerPhone,
                                      totalPrice: _calculateTotal(context
                                          .read<TransactionCubit>()
                                          .state),
                                      orderType:
                                          state.orderType, // Include order type
                                      cashRegisterId: _authSharedPref
                                          .getCachedCashRegisterId(),
                                      createdAt:
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(DateTime.now()),
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PaymentDialog(
                                          fullTransaction: fullTransaction,
                                        );
                                      },
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor:
                                  isEmpty ? Colors.grey : AppColors.primaryMain,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: Text('Bayar',
                                style: AppTextStyle.headline5
                                    .copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context,
      {required String label, required String value, required bool selected}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<TransactionCubit>().updateOrderType(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryMain.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: selected ? AppColors.primaryMain : Colors.grey,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: context.read<TransactionCubit>().state.orderType,
                onChanged: (value) {
                  context.read<TransactionCubit>().updateOrderType(value!);
                },
                activeColor: AppColors.primaryMain,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: selected
                    ? AppTextStyle.body3.copyWith(color: AppColors.primaryMain)
                    : AppTextStyle.body3.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

 double _calculateSubtotal(TransactionState state) {
  return state.transactions.fold(
    0.0, // Initial value is a double
    (total, transaction) => total + (transaction.product.totalPrice?.toDouble() ?? 0.0),
  );
}


  double _calculateSubtotalDisc(TransactionState state) {
  return state.transactions.fold(
    0.0, // Initial value as a double
    (total, transaction) => total + (transaction.product.totalPriceDisc ?? 0.0),
  );
}


  double _calculateDiscount(TransactionState state) {
    final subtotalDisc = _calculateSubtotal(state);
      final productDiscount = _calculateSubtotalDisc(state);
      final subtotal = subtotalDisc - productDiscount;
    double discountAmount = state.discount;
    if (state.voucher != null) {
      if (state.voucher!.type == 'nominal') {
        discountAmount += state.voucher!.amount;
      } else if (state.voucher!.type == 'percentage') {
        discountAmount += (subtotal * state.voucher!.amount / 100);
      }
    }
    return discountAmount;
  }

  double _calculateTotal(TransactionState state) {
    final subtotal = _calculateSubtotal(state);
    final discount = _calculateDiscount(state);
    final productDiscount = _calculateSubtotalDisc(state);

    print("hehe subtotal ${subtotal}");
    print("hehe discount ${discount}");
    print("hehe prod ${productDiscount}");
    final totalAfterDiscount = subtotal - discount-productDiscount;
    print("hehe total after ${totalAfterDiscount}");
    final tax = state.tax / 100 * totalAfterDiscount;
    print("hehe tax ${tax}");
    return (totalAfterDiscount + tax);
  }

  double _getTax(TransactionState state) {
    final subtotal = _calculateSubtotal(state);
    final discount = _calculateDiscount(state);
     final productDiscount = _calculateSubtotalDisc(state);
    final totalAfterDiscount = subtotal - discount-productDiscount;
    final tax = state.tax / 100 * totalAfterDiscount;

    // Membatasi angka di belakang koma menjadi 1 digit
    return double.parse(tax.toStringAsFixed(1));
  }
}
