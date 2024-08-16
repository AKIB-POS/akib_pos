import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:flutter/material.dart';



class SaveTransactionDialog extends StatefulWidget {
  final Function(String) onSave;

  SaveTransactionDialog({required this.onSave});

  @override
  _SaveTransactionDialogState createState() => _SaveTransactionDialogState();
}

class _SaveTransactionDialogState extends State<SaveTransactionDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonDisabled = true; // Initially, the button is disabled

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateInput);
    _controller.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isButtonDisabled = _controller.text.trim().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Container(
              decoration: AppThemes.topBoxDecorationDialog,
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Simpan Pesanan', style: AppTextStyle.headline5),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Keterangan',
                      style: AppTextStyle.headline6.copyWith(color: AppColors.primaryMain),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      decoration: AppThemes.inputDecorationStyle.copyWith(
                        hintText: 'Contoh : Nama Pelanggan, No Table, dsb',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: AppThemes.bottomBoxDecorationDialog,
              child: ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        widget.onSave(_controller.text);
                        Navigator.of(context).pop();
                      },
                style: ButtonStyle(
                  backgroundColor: _isButtonDisabled
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
                child: const Text(
                  'Simpan Pesanan',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}