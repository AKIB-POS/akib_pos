import 'package:flutter/material.dart';

class CashierLandscape extends StatelessWidget {
  const CashierLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Kasir Landscape Mode',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}