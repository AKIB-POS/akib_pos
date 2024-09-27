import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/employee_warning.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeWarningCubit extends Cubit<EmployeeWarningState> {
  final HRDRepository repository;

  EmployeeWarningCubit(this.repository) : super(EmployeeWarningInitial());

  Future<void> fetchEmployeeWarnings() async {
    emit(EmployeeWarningLoading());

    final result = await repository.getEmployeeWarnings();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(EmployeeWarningError(failure.message));
        } else {
          emit(const EmployeeWarningError('Failed to fetch employee warnings.'));
        }
      },
      (warnings) {
        emit(EmployeeWarningLoaded(warnings));
      },
    );
  }
}



abstract class EmployeeWarningState extends Equatable {
  const EmployeeWarningState();

  @override
  List<Object?> get props => [];
}

class EmployeeWarningInitial extends EmployeeWarningState {}

class EmployeeWarningLoading extends EmployeeWarningState {}

class EmployeeWarningLoaded extends EmployeeWarningState {
  final List<EmployeeWarning> employeeWarnings;

  const EmployeeWarningLoaded(this.employeeWarnings);

  @override
  List<Object?> get props => [employeeWarnings];
}

class EmployeeWarningError extends EmployeeWarningState {
  final String message;

  const EmployeeWarningError(this.message);

  @override
  List<Object?> get props => [message];
}
