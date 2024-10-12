import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/dashboard/data/models/branch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchInteractionCubit extends Cubit<BranchInteractionState> {
  final AuthSharedPref authSharedPref;

  BranchInteractionCubit({required this.authSharedPref})
      : super(BranchInteractionState(
          branchId: authSharedPref.getBranchId() ?? 0,
          branchName: '',
        )) {
    // Panggil fungsi untuk memuat branch yang tersimpan di SharedPref saat cubit diinisialisasi
    loadInitialBranch();
  }

  Future<void> loadInitialBranch() async {
    final branchId = authSharedPref.getBranchId();
    final branchList = authSharedPref.getBranchList();

    if (branchId != null && branchId != 0 && branchList.isNotEmpty) {
      // Cari branch dengan branchId yang tersimpan di SharedPref
      final branch = branchList.firstWhere(
        (b) => b.id == branchId,
        orElse: () => Branch(id: 0, branchName: 'Branch Not Found', address: '', phone: '', email: ''),
      );

      emit(state.copyWith(branchId: branch.id, branchName: branch.branchName));
    } else {
      emit(state.copyWith(branchName: 'Pilih Cabang'));
    }
  }

  Future<void> selectBranch(Branch branch) async {
    emit(state.copyWith(branchId: branch.id, branchName: branch.branchName));
    // Simpan branch terpilih ke SharedPreferences
    await authSharedPref.saveBranchId(branch.id);
  }
}



class BranchInteractionState {
  final int branchId;
  final String branchName;
  final bool isLoading;

  BranchInteractionState({
    required this.branchId,
    required this.branchName,
    this.isLoading = false,
  });

  BranchInteractionState copyWith({
    int? branchId,
    String? branchName,
    bool? isLoading,
  }) {
    return BranchInteractionState(
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
