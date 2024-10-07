import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/employee_sop.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeSOPCubit extends Cubit<EmployeeSOPState> {
  final HRDRepository repository;

  EmployeeSOPCubit(this.repository) : super(EmployeeSOPInitial());

  Future<void> fetchEmployeeSOP() async {
    emit(EmployeeSOPLoading());

    final result = await repository.getEmployeeSOP();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(EmployeeSOPError(failure.message));
        } else {
          emit(const EmployeeSOPError('Failed to fetch employee SOP.'));
        }
      },
      (sopResponse) {
        emit(EmployeeSOPLoaded(sopResponse));
      },
    );
  }
}

abstract class EmployeeSOPState extends Equatable {
  const EmployeeSOPState();

  @override
  List<Object> get props => [];
}

class EmployeeSOPInitial extends EmployeeSOPState {}

class EmployeeSOPLoading extends EmployeeSOPState {}

class EmployeeSOPLoaded extends EmployeeSOPState {
  final EmployeeSOPResponse sopResponse;

  const EmployeeSOPLoaded(this.sopResponse);

  @override
  List<Object> get props => [sopResponse];
}

class EmployeeSOPError extends EmployeeSOPState {
  final String message;

  const EmployeeSOPError(this.message);

  @override
  List<Object> get props => [message];
}
