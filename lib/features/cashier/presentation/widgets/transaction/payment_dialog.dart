import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PaymentDialog extends StatefulWidget {
  final FullTransactionModel fullTransaction;

  PaymentDialog({Key? key, required this.fullTransaction}) : super(key: key);

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String? selectedPaymentMethod;
  String? selectedCashOption;
  bool isLoading = false;
  final TextEditingController customCashController = TextEditingController();
  bool isButtonDisabled = true; // Initial state for button disabled

  @override
  void initState() {
    super.initState();
    customCashController.addListener(_validateInput);
  }

  @override
  void dispose() {
    customCashController.removeListener(_validateInput);
    customCashController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      isButtonDisabled = selectedCashOption == null &&
          selectedPaymentMethod == null &&
          (customCashController.text.isEmpty);
    });
  }

  void _handlePayment() {
    if (isButtonDisabled) return;

    setState(() {
      isLoading = true;
    });

    double paymentAmount = widget.fullTransaction.totalPrice;
    String paymentMethod = selectedPaymentMethod ?? "Tunai";

    if (selectedCashOption != null) {
      if (selectedCashOption == "Uang Pas") {
        paymentAmount = widget.fullTransaction.totalPrice;
      } else {
        paymentAmount = double.tryParse(selectedCashOption!) ?? 0;
      }
    } else if (customCashController.text.isNotEmpty) {
      paymentAmount = double.tryParse(customCashController.text.replaceAll(RegExp(r'[^0-9]'), ''))?.toDouble() ?? 0;
      if (paymentAmount < widget.fullTransaction.totalPrice) {
        // Display an error if custom cash input is less than the total price
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nominal tunai tidak boleh kurang dari total tagihan'),
        ));
        setState(() {
          isLoading = false;
        });
        return;
      }
    } else if (selectedPaymentMethod != null) {
      paymentAmount = widget.fullTransaction.totalPrice;
    }

    // Update the transaction model
    widget.fullTransaction.paymentMethod = paymentMethod;
    widget.fullTransaction.paymentAmount = paymentAmount;

    // Print JSON for testing purpose
    print(widget.fullTransaction.toJson());

    // Simulate API call delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              decoration: AppThemes.topBoxDecorationDialog,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Total Tagihan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${widget.fullTransaction.totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildPaymentOptions(),
              ),
            ),
            const SizedBox(height: 16),
            _buildBayarButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBayarButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppThemes.bottomBoxDecorationDialog,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: isButtonDisabled
              ? WidgetStatePropertyAll<Color>(Colors.grey)
              : const WidgetStatePropertyAll<Color>(AppColors.primaryMain),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 16),
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        onPressed: isLoading ? null : _handlePayment,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Bayar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    final int total = widget.fullTransaction.totalPrice.toInt();
    final List<int> cashOptions = _generateCashOptions(total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tunai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCashButtons(cashOptions),
        const SizedBox(height: 8),
        _buildCustomCashInput(),
        const SizedBox(height: 16),
        const Text('QRIS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildQRISButtons(),
      ],
    );
  }

  Widget _buildCashButtons(List<int> cashOptions) {
    return AutoHeightGridView(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cashOptions.length + 1,
      builder: (context, index) {
        if (index == 0) {
          return _buildCashButton(
            'Uang Pas',
            () {
              setState(() {
                selectedCashOption = 'Uang Pas';
                selectedPaymentMethod = null;
                customCashController.clear();
                FocusScope.of(context).unfocus();
              });
              _validateInput();
            },
            isSelected: selectedCashOption == 'Uang Pas',
          );
        }
        final option = cashOptions[index - 1];
        return _buildCashButton(
          option.toString(),
          () {
            setState(() {
              selectedCashOption = option.toString();
              selectedPaymentMethod = null;
              customCashController.clear();
              FocusScope.of(context).unfocus();
            });
            _validateInput();
          },
          isSelected: selectedCashOption == option.toString(),
        );
      },
    );
  }

  Widget _buildCashButton(String label, VoidCallback onPressed, {bool isSelected = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEF4F2) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFDFE3E8),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Center(
          child: Text(label, style: TextStyle(fontSize: 16, color: isSelected ? Colors.black : Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildCustomCashInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: customCashController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
              CurrencyTextInputFormatter.currency(
                locale: 'id',
                decimalDigits: 0,
                symbol: 'Rp.  ',
              ),
            ],
        decoration: AppThemes.inputDecorationStyle.copyWith(hintText: "Masukkan Nominal Lainnya"),
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = null;
            selectedCashOption = null;
          });
          _validateInput();
        },
      ),
    );
  }

  Widget _buildQRISButtons() {
    final paymentMethods = [
      {'method': 'gopay', 'icon': 'assets/icons/gopay.png'},
      {'method': 'dana', 'icon': 'assets/icons/dana.png'},
      {'method': 'shopee_pay', 'icon': 'assets/icons/shopee_pay.png'},
      {'method': 'ovo', 'icon': 'assets/icons/ovo.png'},
      {'method': 'bri', 'icon': 'assets/icons/bri.png'},
      {'method': 'bca', 'icon': 'assets/icons/bca.png'},
      {'method': 'bni', 'icon': 'assets/icons/bni.png'},
      {'method': 'mandiri', 'icon': 'assets/icons/mandiri.png'},
    ];

    return AutoHeightGridView(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paymentMethods.length,
      builder: (context, index) {
        final method = paymentMethods[index]['method']!;
        final icon = paymentMethods[index]['icon']!;
        return _buildQRISButton(method, icon);
      },
    );
  }

  Widget _buildQRISButton(String paymentMethod, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = paymentMethod;
          selectedCashOption = null;
          customCashController.clear();
          FocusScope.of(context).unfocus();
        });
        _validateInput();
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedPaymentMethod == paymentMethod ? const Color(0xFFFEF4F2) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedPaymentMethod == paymentMethod ? Colors.transparent : const Color(0xFFDFE3E8),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Center(
          child: Image.asset(assetPath, fit: BoxFit.contain, height: 28),
        ),
      ),
    );
  }

  List<int> _generateCashOptions(int total) {
    List<int> denom = [1000, 2000, 5000, 10000, 20000, 50000, 100000];
    List<int> cashOptions = [];

    int baseAmount = denom.reversed.firstWhere((d) => d <= total);

    while (cashOptions.length < 3) {
      for (int d in denom) {
        int candidate = baseAmount + d;
        if (candidate > total && !cashOptions.contains(candidate)) {
          cashOptions.add(candidate);
          if (cashOptions.length == 3) break;
        }
      }
      baseAmount += denom[0];
    }

    return cashOptions;
  }
}