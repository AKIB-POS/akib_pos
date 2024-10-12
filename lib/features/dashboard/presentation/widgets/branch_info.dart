import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/branch_interaction_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_branches_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class BranchInfo extends StatelessWidget {
  final VoidCallback onTap;

  const BranchInfo({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<BranchInteractionCubit, BranchInteractionState>(
              builder: (context, state) {
                return Text(
                  state.branchName.isNotEmpty ? state.branchName : 'Pilih Cabang',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                );
              },
            ),
            const Icon(Icons.store, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
