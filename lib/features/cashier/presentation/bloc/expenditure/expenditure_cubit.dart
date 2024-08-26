import 'package:akib_pos/features/cashier/data/models/expenditure_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenditureCubit extends Cubit<ExpenditureState> {
  final KasirRepository repository;

  ExpenditureCubit({required this.repository}) : super(ExpenditureState());

  Future<void> submitExpenditure(ExpenditureModel expenditure) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));

    final result = await repository.postExpenditure(expenditure);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: "Failed to submit expenditure")),
      (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }
}

class ExpenditureState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  ExpenditureState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  ExpenditureState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return ExpenditureState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
