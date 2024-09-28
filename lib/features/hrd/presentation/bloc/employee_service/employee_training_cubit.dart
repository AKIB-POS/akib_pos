import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_training.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeTrainingCubit extends Cubit<EmployeeTrainingState> {
  final HRDRepository repository;

  EmployeeTrainingCubit(this.repository) : super(EmployeeTrainingInitial());

  Future<void> fetchEmployeeTrainings({required int branchId}) async {
    emit(EmployeeTrainingLoading());

    final result = await repository.getEmployeeTrainings(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(EmployeeTrainingError(failure.message));
        } else {
          emit(EmployeeTrainingError('Failed to fetch training data.'));
        }
      },
      (trainingData) {
        emit(EmployeeTrainingLoaded(trainingData));
      },
    );
  }
}
abstract class EmployeeTrainingState extends Equatable {
  const EmployeeTrainingState();

  @override
  List<Object> get props => [];
}

class EmployeeTrainingInitial extends EmployeeTrainingState {}

class EmployeeTrainingLoading extends EmployeeTrainingState {}

class EmployeeTrainingLoaded extends EmployeeTrainingState {
  final EmployeeTrainingResponse trainingData;

  const EmployeeTrainingLoaded(this.trainingData);

  @override
  List<Object> get props => [trainingData];
}

class EmployeeTrainingError extends EmployeeTrainingState {
  final String message;

  const EmployeeTrainingError(this.message);

  @override
  List<Object> get props => [message];
}