import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/save_transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/process_transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/printer_management_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/payment_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/product_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/save_transaction_dialog.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class RightBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                return ListView.builder(
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactions[index];
                    return Container(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ExtendedImage.network(
                                    transaction.product.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.fill,
                                    cache: true,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ProductDialog(
                                              product: transaction.product,
                                              editIndex: index,
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Edit',
                                              style: AppTextStyle.subtitle2
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(transaction.product.name,
                                        style: AppTextStyle.headline6),
                                    const SizedBox(height: 2),
                                    Text(
                                        Utils.formatCurrency(transaction
                                            .product.totalPrice
                                            .toString()),
                                        style: AppTextStyle.body3),
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
                                        onPressed: () {
                                          context
                                              .read<TransactionCubit>()
                                              .subtractQuantity(index);
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      Text(transaction.quantity.toString(),
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
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Diskon',
                                      style: AppTextStyle.body3),
                                  Text(
                                      Utils.formatCurrencyDouble(
                                          _calculateDiscount(context
                                              .read<TransactionCubit>()
                                              .state)),
                                      style: AppTextStyle.body3),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Pajak(PPN)',
                                      style: AppTextStyle.body3),
                                  Text("${state.tax}%",
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
              final isEmpty = state.transactions.isEmpty;
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
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PrinterManagementDialog();
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.primaryMain),
                                color: Colors.white, // White background color
                                borderRadius: BorderRadius.circular(
                                    4.0), // Border radius of 4
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/ic_print.svg",
                                height: 2.h,
                                colorFilter: ColorFilter.mode(
                                    AppColors.primaryMain, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
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

                                            await context
                                                .read<TransactionCubit>()
                                                .saveFullTransaction(
                                                    transactions, notes);
                                            // Get the saved full transactions count and update the badge count
                                            List<SaveTransactionModel>
                                                savedFullTransactions =
                                                await context
                                                    .read<TransactionCubit>()
                                                    .getFullTransactions();
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
                                            customerPhone: state.customerPhone,
                                            totalPrice: _calculateTotal(context
                                                .read<TransactionCubit>()
                                                .state));

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

  double _calculateSubtotal(TransactionState state) {
    print("${state.transactions}");
    return state.transactions.fold(
        0, (total, transaction) => total + transaction.product.totalPrice!);
  }

  double _calculateDiscount(TransactionState state) {
    final subtotal = _calculateSubtotal(state);

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
    print("apa statenya ${state.transactions}");
    final subtotal = _calculateSubtotal(state);
    final discount = _calculateDiscount(state);
    final totall = subtotal - discount;
    final tax = state.tax / 100 * totall;
    return (subtotal + tax);
  }

  double _getTax(TransactionState state) {
    print("apa statenya ${state.transactions}");
    final subtotal = _calculateSubtotal(state);
    final discount = _calculateDiscount(state);
    final totall = subtotal - discount;
    final tax = state.tax / 100 * totall;
    return (tax);
  }
}
