import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/submit_employee_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitEmployeePerformanceCubit extends Cubit<SubmitEmployeePerformanceState> {
  final HRDRepository repository;

  SubmitEmployeePerformanceCubit(this.repository) : super(SubmitEmployeePerformanceInitial());

  Future<void> submitPerformance(SubmitEmployeePerformanceRequest request) async {
    emit(SubmitEmployeePerformanceLoading());

    final result = await repository.submitEmployeePerformance(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SubmitEmployeePerformanceError(failure.message));
        } else {
          emit(SubmitEmployeePerformanceError('Failed to submit performance.'));
        }
      },
      (_) {
        emit(SubmitEmployeePerformanceSuccess('Employee performance submitted successfully.'));
      },
    );
  }
}

abstract class SubmitEmployeePerformanceState extends Equatable {
  const SubmitEmployeePerformanceState();

  @override
  List<Object> get props => [];
}

class SubmitEmployeePerformanceInitial extends SubmitEmployeePerformanceState {}

class SubmitEmployeePerformanceLoading extends SubmitEmployeePerformanceState {}

class SubmitEmployeePerformanceSuccess extends SubmitEmployeePerformanceState {
  final String message;

  const SubmitEmployeePerformanceSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SubmitEmployeePerformanceError extends SubmitEmployeePerformanceState {
  final String message;

  const SubmitEmployeePerformanceError(this.message);

  @override
  List<Object> get props => [message];
}
