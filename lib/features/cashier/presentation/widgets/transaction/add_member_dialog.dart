import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';// Pastikan untuk mengimpor MemberCubit

class AddMemberDialog extends StatefulWidget {
  final VoidCallback onSuccess; // Callback untuk keberhasilan post

  const AddMemberDialog({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MemberCubit, MemberState>(
      listener: (context, state) {
        if (state is MemberPosting) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is MemberPostedSuccess) {
          setState(() {
            _isLoading = false;
          });
          DInfo.snackBarSuccess(context, "Member berhasil ditambahkan");
          Navigator.of(context).pop();
          widget.onSuccess(); // Panggil callback ketika berhasil
        } else if (state is MemberError) {
          setState(() {
            _isLoading = false;
          });
          DInfo.snackBarError(context, "Gagal menambahkan member");
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Sesuaikan tinggi dialog dengan kontennya
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tambah Member', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nama'),
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
                  decoration: InputDecoration(labelText: 'Nomor Telepon'),
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
                  decoration: InputDecoration(labelText: 'Email (Opsional)'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<MemberCubit>().postMember(
                                    _nameController.text,
                                    _phoneController.text,
                                    email: _emailController.text.isNotEmpty ? _emailController.text : null,
                                  );
                            }
                          },
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
