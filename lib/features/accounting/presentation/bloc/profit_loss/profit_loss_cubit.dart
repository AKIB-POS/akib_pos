import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/profit_loss/profit_loss_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfitLossCubit extends Cubit<ProfitLossState> {
  final AccountingRepository repository;

  ProfitLossCubit({
    required this.repository,
  }) : super(ProfitLossInitial());

  Future<void> fetchProfitLoss({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    try {
      emit(ProfitLossLoading());
      final result = await repository.getProfitLoss(
        branchId: branchId,
        companyId: companyId,
        date: date,
      );
      result.fold(
        (failure) => emit(ProfitLossError(_mapFailureToMessage(failure))),
        (profitLoss) => emit(ProfitLossLoaded(profitLoss)),
      );
    } catch (e) {
      emit(ProfitLossError(e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else if (failure is GeneralFailure) {
      return failure.message;
    } else {
      return 'Unexpected Error';
    }
  }
}
abstract class ProfitLossState {}

class ProfitLossInitial extends ProfitLossState {}

class ProfitLossLoading extends ProfitLossState {}

class ProfitLossLoaded extends ProfitLossState {
  final ProfitLossModel profitLoss;

  ProfitLossLoaded(this.profitLoss);
}

class ProfitLossError extends ProfitLossState {
  final String message;

  ProfitLossError(this.message);
}
