import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_member_dialog.dart';  // Pastikan untuk mengimpor AddMemberDialog

class MemberDialog extends StatefulWidget {
  @override
  _MemberDialogState createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().getAllMembers(); // Memuat semua member saat dialog dibuka

    // Menambahkan listener untuk mendeteksi perubahan teks
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    // Membersihkan listener ketika widget ini dihapus
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_searchController.text.isEmpty) {
      // Jika teks kosong, muat ulang semua data member
      context.read<MemberCubit>().getAllMembers();
    }
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      insetPadding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.05, // 5% top & bottom padding
        horizontal: MediaQuery.of(context).size.width * 0.15, // 15% left & right padding
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7, // 70% of screen width
        height: MediaQuery.of(context).size.height * 0.9, // 90% of screen height
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Enter member name',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final query = _searchController.text;
                    if (query.isNotEmpty) {
                      context.read<MemberCubit>().searchMemberByName(query);
                    } else {
                      context.read<MemberCubit>().getAllMembers(); // Kembali ke daftar semua member
                    }
                  },
                  child: Icon(Icons.search),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showAddMemberDialog(context),
                  child: Text('Tambah Pelanggan'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<MemberCubit, MemberState>(
                builder: (context, state) {
                  if (state is MemberLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is MemberLoaded) {
                    return ListView.builder(
                      itemCount: state.members.length,
                      itemBuilder: (context, index) {
                        final member = state.members[index];
                        return ListTile(
                          title: Text(member.name),
                          subtitle: Text(member.email ?? "No email"),
                        );
                      },
                    );
                  } else if (state is MemberError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text('Please search for a member or wait while members are loading'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
