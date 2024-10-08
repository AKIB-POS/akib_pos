import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/add_vendor.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddVendorPage extends StatefulWidget {
  const AddVendorPage({Key? key}) : super(key: key);

  @override
  State<AddVendorPage> createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vendorNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listeners to the text fields to update the form validation state
    _vendorNameController.addListener(_onFormFieldChanged);
    _phoneNumberController.addListener(_onFormFieldChanged);
    _addressController.addListener(_onFormFieldChanged);
  }

  // This method is triggered whenever a form field is updated
  void _onFormFieldChanged() {
    setState(() {});  // Triggers a rebuild to re-check the form's validity
  }

  bool _isFormValid() {
    return _vendorNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _addressController.text.isNotEmpty;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final branchId = GetIt.instance<AuthSharedPref>().getBranchId() ?? 1;
      final request = AddVendorRequest(
        branchId: branchId,
        vendorName: _vendorNameController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
      );
      context.read<AddVendorCubit>().addVendor(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Tambah Vendor', style: AppTextStyle.headline5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              const Text('Nama Vendor', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vendorNameController,
                decoration: AppThemes.inputDecorationStyle
                    .copyWith(hintText: 'Masukkan Nama Vendor'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Nama vendor tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Nomor Telepon', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: AppThemes.inputDecorationStyle
                    .copyWith(hintText: 'Masukkan Nomor Telepon'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Nomor telepon tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Alamat', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: AppThemes.inputDecorationStyle
                    .copyWith(hintText: 'Masukkan Alamat'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Alamat tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: AppThemes.bottomBoxDecorationDialog,
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AddVendorCubit, AddVendorState>(
          listener: (context, state) {
            if (state is AddVendorSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vendor berhasil ditambahkan'),
                  backgroundColor: AppColors.successMain,
                ),
              );
              Navigator.of(context).pop(true);
            } else if (state is AddVendorError) {
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
              onPressed:
                  _isFormValid() && state is! AddVendorLoading ? _submit : null,
              child: state is AddVendorLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Kirim', style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when not needed to free up resources
    _vendorNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
