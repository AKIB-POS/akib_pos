
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/data/models/member_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/member/edit_member_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'add_member_dialog.dart';  // Pastikan untuk mengimpor AddMemberDialog

class MemberDialog extends StatefulWidget {
  @override
  _MemberDialogState createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isListEmpty = false;
  int? _selectedCustomerId;
  String? _selectedCustomerName;
  String? _selectedCustomerPhone;

  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().getAllMembers(); // Load all members on dialog open
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_searchController.text.isEmpty) {
      context.read<MemberCubit>().getAllMembers();
    }
  }

  void _searchMembers() {
    _unfocusSearchField();
    final query = _searchController.text;
    if (query.isNotEmpty) {
      context.read<MemberCubit>().searchMemberByName(query);
    } else {
      context.read<MemberCubit>().getAllMembers();
    }
  }

  void _unfocusSearchField() {
    _focusNode.unfocus();
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: context.read<MemberCubit>(),
          child: AddMemberDialog(
            onSuccess: () {
              context.read<MemberCubit>().getAllMembers(); // Reload members after successful post
            },
          ),
        );
      },
    );
  }

  void _showEditMemberDialog(BuildContext context, MemberModel member) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: context.read<MemberCubit>(),
          child: EditMemberDialog(
            member: member,
            onSuccess: () {
              context.read<MemberCubit>().getAllMembers(); // Reload members after successful update
            },
          ),
        );
      },
    );
  }

  void _saveSelectedCustomer() {
    if (_selectedCustomerId != null && _selectedCustomerName != null) {
      context.read<TransactionCubit>().updateCustomer(
          _selectedCustomerId!, _selectedCustomerName!, _selectedCustomerPhone!);
      Navigator.of(context).pop(); // Close dialog after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusSearchField,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                decoration: AppThemes.topBoxDecorationDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Detail Pelanggan', style: AppTextStyle.headline6),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: AppThemes.inputDecorationStyle.copyWith(
                          hintText: "Masukkan nama pelanggan",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.black),
                            onPressed: _searchMembers,
                          ),
                        ),
                        onSubmitted: (_) => _searchMembers(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showAddMemberDialog(context),
                      icon: const Icon(Icons.add, size: 21),
                      label: const Text('Tambah Pelanggan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryMain,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<MemberCubit, MemberState>(
                  builder: (context, state) {
                    if (state is MemberLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MemberLoaded) {
                      _isListEmpty = state.members.isEmpty;
                      if (_isListEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.builder(
                        itemCount: state.members.length,
                        itemBuilder: (context, index) {
                          final member = state.members[index];
                          final isSelected = _selectedCustomerId == member.id;
                          return ListTile(
                            leading: SvgPicture.asset(
                                "assets/icons/ic_members.svg",
                                height: 24,
                                width: 24,
                              ),
                            title: Text(member.name,style: AppTextStyle.headline6),
                            subtitle: Text(member.phoneNumber,style: AppTextStyle.body2),
                            tileColor: isSelected ? AppColors.primaryMain.withOpacity(0.3) : null,
                            trailing: ElevatedButton.icon(
                              icon: const Icon(Icons.edit, size: 16,color: Colors.white,),
                              onPressed: () => _showEditMemberDialog(context, member),
                              label: const Text('Edit', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryMain,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                minimumSize: const Size(0, 30),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedCustomerId = member.id;
                                _selectedCustomerName = member.name;
                                _selectedCustomerPhone = member.phoneNumber;
                              });
                            },
                          );
                        },
                      );
                    } else if (state is MemberError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: Text('Please search for a member or wait while members are loading'));
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCustomerId != null ? AppColors.primaryMain : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _selectedCustomerId != null ? _saveSelectedCustomer : null,
                  child: const Text(
                    'Simpan',
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

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/images/empty_saved.svg",
        ),
        const SizedBox(height: 16),
        const Text(
          'Belum ada pelanggan',
          style: AppTextStyle.headline5,
        ),
        const Text(
          'Silahkan tambahkan pelanggan',
          style: AppTextStyle.body2,
        ),
      ],
    );
  }
}
