import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/data/models/expenditure_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/expenditure/expenditure_cubit.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenditureDialog extends StatefulWidget {
  @override
  _ExpenditureDialogState createState() => _ExpenditureDialogState();
}

class _ExpenditureDialogState extends State<ExpenditureDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _deskripsiController = TextEditingController();

  bool _isFormValid() {
    return _tanggalController.text.isNotEmpty &&
        _jumlahController.text.isNotEmpty &&
        _kategoriController.text.isNotEmpty &&
        _deskripsiController.text.isNotEmpty;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMain,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryMain,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final expenditure = ExpenditureModel(
        tanggal: _tanggalController.text,
        jumlah: int.tryParse(
                  _jumlahController.text.replaceAll(RegExp(r'[^0-9]'), ''))
              ?.toInt() ?? 0,
        kategori: _kategoriController.text,
        deskripsi: _deskripsiController.text,
      );

      context.read<ExpenditureCubit>().submitExpenditure(expenditure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              decoration: AppThemes.topBoxDecorationDialog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pengeluaran Baru', style: AppTextStyle.headline5),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<ExpenditureCubit, ExpenditureState>(
                listener: (context, state) {
                  if (state.isSuccess) {
                    Navigator.of(context).pop(); // Close the dialog on success
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Berhasil Menyimpan Pengeluaran',
                        ),
                        backgroundColor: AppColors.successMain,
                      ),
                    );
                  } else if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage!)),
                    );
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Form(
                      key: _formKey,
                      onChanged: () => setState(() {}),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _tanggalController,
                            decoration: AppThemes.inputDecorationStyle
                                .copyWith(hintText: 'Pilih Tanggal'),
                            validator: (value) {
                              if (value?.isEmpty ?? true)
                                return "Tanggal tidak boleh kosong";
                              return null;
                            },
                            readOnly: true,
                            onTap: () => _selectDate(context),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _jumlahController,
                            inputFormatters: <TextInputFormatter>[
                              CurrencyTextInputFormatter.currency(
                                locale: 'id',
                                decimalDigits: 0,
                                symbol: 'Rp.  ',
                              ),
                            ],
                            decoration: AppThemes.inputDecorationStyle
                                .copyWith(hintText: 'Jumlah'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true)
                                return "Jumlah tidak boleh kosong";
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _kategoriController,
                            decoration: AppThemes.inputDecorationStyle
                                .copyWith(hintText: 'Masukkan Kategori'),
                            validator: (value) {
                              if (value?.isEmpty ?? true)
                                return "Kategori tidak boleh kosong";
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _deskripsiController,
                            decoration: AppThemes.inputDecorationStyle
                                .copyWith(hintText: 'Masukkan Deskripsi'),
                            validator: (value) {
                              if (value?.isEmpty ?? true)
                                return "Deskripsi tidak boleh kosong";
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<ExpenditureCubit, ExpenditureState>(
              builder: (context, state) {
                bool isLoading = state.isLoading;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: AppThemes.bottomBoxDecorationDialog,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: _isFormValid() && !isLoading
                          ? const WidgetStatePropertyAll<Color>(
                              AppColors.primaryMain)
                          : const WidgetStatePropertyAll<Color>(Colors.grey),
                      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: _isFormValid() && !isLoading ? _submit : null,
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
