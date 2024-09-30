import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/permanent_employee_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermanentEmployeeCubit extends Cubit<PermanentEmployeeState> {
  final HRDRepository repository;

  PermanentEmployeeCubit(this.repository) : super(PermanentEmployeeInitial());

  Future<void> fetchPermanentEmployeeDetail(int employeeId) async {
    emit(PermanentEmployeeLoading());

    final result = await repository.getPermanentEmployeeDetail(employeeId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PermanentEmployeeError(failure.message));
        } else {
          emit(PermanentEmployeeError('Failed to fetch permanent employee detail.'));
        }
      },
      (permanentEmployeeDetail) {
        emit(PermanentEmployeeLoaded(permanentEmployeeDetail));
      },
    );
  }
}

abstract class PermanentEmployeeState extends Equatable {
  const PermanentEmployeeState();

  @override
  List<Object> get props => [];
}

class PermanentEmployeeInitial extends PermanentEmployeeState {}

class PermanentEmployeeLoading extends PermanentEmployeeState {}

class PermanentEmployeeLoaded extends PermanentEmployeeState {
  final PermanentEmployeeDetail permanentEmployeeDetail;

  const PermanentEmployeeLoaded(this.permanentEmployeeDetail);

  @override
  List<Object> get props => [permanentEmployeeDetail];
}

class PermanentEmployeeError extends PermanentEmployeeState {
  final String message;

  const PermanentEmployeeError(this.message);

  @override
  List<Object> get props => [message];
}