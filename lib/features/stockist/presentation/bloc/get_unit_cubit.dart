import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/unit.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUnitCubit extends Cubit<GetUnitState> {
  final StockistRepository repository;

  GetUnitCubit(this.repository) : super(GetUnitInitial());

  Future<void> fetchUnits({required int branchId}) async {
    emit(GetUnitLoading());

    final result = await repository.getUnits(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetUnitError(failure.message));
        } else {
          emit(GetUnitError('Failed to fetch units.'));
        }
      },
      (unitsResponse) {
        emit(GetUnitLoaded(unitsResponse));
      },
    );
  }
}

abstract class GetUnitState {}

class GetUnitInitial extends GetUnitState {}

class GetUnitLoading extends GetUnitState {}

class GetUnitLoaded extends GetUnitState {
  final GetUnitsResponse unitsResponse;

  GetUnitLoaded(this.unitsResponse);
}

class GetUnitError extends GetUnitState {
  final String message;

  GetUnitError(this.message);
}
