import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/product_dialog.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      child: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text("No transactions yet"));
          }

          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
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
                              width: 90,
                              height: 90,
                              fit: BoxFit.fill,
                              cache: true,
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
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
                                    Text('Edit', style: AppTextStyle.subtitle2.copyWith(color: AppColors.primaryMain)),
                                    const SizedBox(width: 4),
                                    Icon(
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
                              Text(transaction.product.name, style: AppTextStyle.headline6),
                              const SizedBox(height: 2),
                              Text(Utils.formatCurrency(transaction.product.totalPrice.toString()), style: AppTextStyle.body3),
                              const SizedBox(height: 8),
                              Text('Catatan: ${transaction.notes}', style: AppTextStyle.body3),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    context.read<TransactionCubit>().subtractQuantity(index);
                                  },
                                ),
                                const SizedBox(width: 8),
                                Text(transaction.quantity.toString(), style: AppTextStyle.headline6),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icons/ic_plus.svg",
                                    height: 28,
                                    width: 28,
                                  ),
                                  onPressed: () {
                                    context.read<TransactionCubit>().addQuantity(index);
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
    );
  }
}