import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/add_equipment_type.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_equipment_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddEquipmentTypePage extends StatefulWidget {
  const AddEquipmentTypePage({Key? key}) : super(key: key);

  @override
  _AddEquipmentTypePageState createState() => _AddEquipmentTypePageState();
}

class _AddEquipmentTypePageState extends State<AddEquipmentTypePage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
  final _formKey = GlobalKey<FormState>();
  String? equipmentName;

  bool _isFormValid() {
    return equipmentName != null && equipmentName!.isNotEmpty;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final branchId = _authSharedPref.getBranchId() ?? 0;
      final request = AddEquipmentTypeRequest(
        branchId: branchId,
        name: equipmentName!,
        category: 'equipment',
      );
      context.read<AddEquipmentTypeCubit>().addEquipmentType(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text(
          'Tambah Jenis Peralatan',
          style: AppTextStyle.headline5,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Peralatan', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              TextFormField(
                decoration: AppThemes.inputDecorationStyle
                    .copyWith(hintText: 'Masukkan Nama Peralatan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama peralatan tidak boleh kosong";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    equipmentName = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: AppThemes.bottomBoxDecorationDialog,
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AddEquipmentTypeCubit, AddEquipmentTypeState>(
          listener: (context, state) {
            if (state is AddEquipmentTypeSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Peralatan berhasil ditambahkan'),
                  backgroundColor: AppColors.successMain,
                ),
              );
              Navigator.of(context).pop(true);
            } else if (state is AddEquipmentTypeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.errorMain,
                ),
              );
            }
          },
          builder: (context, state) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isFormValid() ? AppColors.primaryMain : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _isFormValid() && state is! AddEquipmentTypeLoading
                  ? _submit
                  : null,
              child: state is AddEquipmentTypeLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : const Text('Simpan', style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }
}
