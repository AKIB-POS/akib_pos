import 'package:akib_pos/features/cashier/presentation/pages/cashier_landscape.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_portrait.dart';
import 'package:flutter/material.dart';


class CashierPage extends StatelessWidget {
  final String mode;

  const CashierPage({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return mode == 'portrait' ? const CashierPortrait() : const CashierLandscape();
  }
}