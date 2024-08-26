import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/data/models/member_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditMemberDialog extends StatefulWidget {
  final MemberModel member;
  final VoidCallback onSuccess;

  const EditMemberDialog({Key? key, required this.member, required this.onSuccess}) : super(key: key);

  @override
  _EditMemberDialogState createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool _isLoading = false;
  bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _phoneController = TextEditingController(text: widget.member.phoneNumber);
    _emailController = TextEditingController(text: widget.member.email ?? '');
    _nameController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm);
    _phoneController.removeListener(_validateForm);
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isFormValid = _nameController.text.isNotEmpty && _phoneController.text.isNotEmpty;
    setState(() {
      _isButtonEnabled = isFormValid;
    });
  }

  void _unfocusAllFields() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MemberCubit, MemberState>(
      listener: (context, state) {
        if (state is MemberUpdatedSuccess) {
          setState(() {
            _isLoading = false;
          });
          DInfo.toastSuccess("Member berhasil diperbarui");
          Navigator.of(context).pop();
          widget.onSuccess();
        } else if (state is MemberUpdateError) {
          setState(() {
            _isLoading = false;
          });
          DInfo.toastError("Gagal memperbarui member");
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: AppThemes.allBoxDecorationDialog,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                decoration: AppThemes.topBoxDecorationDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit Member', style: AppTextStyle.headline6),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: AppThemes.inputDecorationStyle.copyWith(
                            hintText: 'Nama',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: AppThemes.inputDecorationStyle.copyWith(
                            hintText: 'Nomor Telepon',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nomor telepon wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: AppThemes.inputDecorationStyle.copyWith(
                            hintText: 'Email (Opsional)',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      _isButtonEnabled ? AppColors.primaryMain : Colors.grey,
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 8),
                    ),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: _isButtonEnabled && !_isLoading
                      ? () {
                          _unfocusAllFields(); // Turunkan keyboard
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _isLoading = true;
                            });
                            context.read<MemberCubit>().updateMember(
                                  MemberModel(
                                    id: widget.member.id,
                                    name: _nameController.text,
                                    phoneNumber: _phoneController.text,
                                    email: _emailController.text.isNotEmpty ? _emailController.text : null,
                                  ),
                                );
                          }
                        }
                      : null,
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
