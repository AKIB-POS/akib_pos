import 'package:flutter/material.dart';

class CashierPortrait extends StatelessWidget {
  const CashierPortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Kasir Portrait Mode',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}