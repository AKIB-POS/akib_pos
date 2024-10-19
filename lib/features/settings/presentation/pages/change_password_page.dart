import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/settings/presentation/bloc/change_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? oldPassword;
  String? newPassword;
  String? confirmPassword;

  bool _isFormValid() {
    return oldPassword != null &&
        newPassword != null &&
        confirmPassword != null &&
        oldPassword!.isNotEmpty &&
        newPassword!.isNotEmpty &&
        confirmPassword!.isNotEmpty;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().changePassword(
            oldPassword: oldPassword!,
            newPassword: newPassword!,
            passwordConfirmation: confirmPassword!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text(
          'Ubah Kata Sandi',
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
              _buildPasswordField(
                label: 'Password Lama',
                isVisible: _isOldPasswordVisible,
                onChanged: (value) {
                  setState(() {
                    oldPassword = value;
                  });
                },
                onVisibilityChanged: () {
                  setState(() {
                    _isOldPasswordVisible = !_isOldPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: 'Password Baru',
                isVisible: _isNewPasswordVisible,
                onChanged: (value) {
                  setState(() {
                    newPassword = value;
                  });
                },
                onVisibilityChanged: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: 'Konfirmasi Password',
                isVisible: _isConfirmPasswordVisible,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
                onVisibilityChanged: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
        child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Berhasil Mengubah Password"),
                  backgroundColor: AppColors.successMain,
                ),
              );
              Navigator.of(context).pop(true); // Return true on success
            } else if (state is ChangePasswordError) {
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
              onPressed: _isFormValid() && state is! ChangePasswordLoading
                  ? _submit
                  : null,
              child: state is ChangePasswordLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Simpan', style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool isVisible,
    required ValueChanged<String> onChanged,
    required VoidCallback onVisibilityChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.bigCaptionBold),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: !isVisible,
          decoration: AppThemes.inputDecorationStyle.copyWith(
            hintText: label,
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: onVisibilityChanged,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label tidak boleh kosong";
            }
            if (label == 'Konfirmasi Password' && value != newPassword) {
              return 'Password konfirmasi tidak cocok';
            }
            return null;
          },
          onChanged: onChanged,
        ),
      ],
    );
  }
}
