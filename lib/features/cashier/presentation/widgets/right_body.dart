import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';


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
            return Center(child: Text("No transactions yet"));
          }

          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: ExtendedImage.network(
                  transaction.product.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.fill,
                  cache: true,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.product.name, style: AppTextStyle.headline6),
                    const SizedBox(height: 2),
                    Text(Utils.formatCurrency(transaction.product.price.toString()), style: AppTextStyle.body3),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Catatan: ${transaction.notes}', style: AppTextStyle.body3),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.edit, color: AppColors.primaryMain),
                          onPressed: () {
                            // Handle edit action
                          },
                        ),
                      ],
                    ),
                    Text(
                      'Variants: ${transaction.selectedVariants?.values.join(', ')}' ?? '',
                      style: AppTextStyle.body3,
                    ),
                    Text(
                      'Additions: ${transaction.selectedAdditions?.values.expand((i) => i).join(', ')}' ?? '',
                      style: AppTextStyle.body3,
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/ic_minus.svg",
                        height: 38,
                        width: 38,
                      ),
                      onPressed: () {
                        // Update quantity logic here
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(transaction.quantity.toString(), style: AppTextStyle.headline6),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/ic_plus.svg",
                        height: 38,
                        width: 38,
                      ),
                      onPressed: () {
                        // Update quantity logic here
                      },
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
