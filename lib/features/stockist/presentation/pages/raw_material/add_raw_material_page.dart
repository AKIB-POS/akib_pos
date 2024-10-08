import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/add_raw_material.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_material_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddRawMaterialPage extends StatefulWidget {
  const AddRawMaterialPage({Key? key}) : super(key: key);

  @override
  _AddRawMaterialPageState createState() => _AddRawMaterialPageState();
}

class _AddRawMaterialPageState extends State<AddRawMaterialPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
  final _formKey = GlobalKey<FormState>();
  String? rawMaterialName;

  bool _isFormValid() {
    return rawMaterialName != null && rawMaterialName!.isNotEmpty;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final branchId = _authSharedPref.getBranchId() ?? 0;
      final request = AddRawMaterialRequest(branchId: branchId, rawMaterialName: rawMaterialName!);
      context.read<AddRawMaterialCubit>().addRawMaterial(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Tambah Bahan Baku',style: AppTextStyle.headline5,),
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
              const Text('Nama Bahan', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              TextFormField(
                decoration: AppThemes.inputDecorationStyle.copyWith(hintText: 'Masukkan Nama Bahan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama bahan tidak boleh kosong";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    rawMaterialName = value;
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
                child: BlocConsumer<AddRawMaterialCubit, AddRawMaterialState>(
                  listener: (context, state) {
                    if (state is AddRawMaterialSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bahan baku berhasil ditambahkan'),
                          backgroundColor: AppColors.successMain,
                        ),
                      );
                      Navigator.of(context).pop(true);
                    } else if (state is AddRawMaterialError) {
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
                        backgroundColor: _isFormValid() ? AppColors.primaryMain : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: _isFormValid() && state is! AddRawMaterialLoading
                          ? _submit
                          : null,
                      child: state is AddRawMaterialLoading
                          ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                          : const Text('Simpan', style: TextStyle(color: Colors.white)),
                    );
                  },
                  
                ),
              ),
    );
  }

}
