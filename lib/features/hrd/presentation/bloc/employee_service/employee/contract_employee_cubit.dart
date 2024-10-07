import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/contract_employee_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractEmployeeCubit extends Cubit<ContractEmployeeState> {
  final HRDRepository repository;

  ContractEmployeeCubit(this.repository) : super(ContractEmployeeInitial());

  Future<void> fetchContractEmployeeDetail(int employeeId) async {
    emit(ContractEmployeeLoading());

    final result = await repository.getContractEmployeeDetail(employeeId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(ContractEmployeeError(failure.message));
        } else {
          emit(ContractEmployeeError('Failed to fetch contract employee detail.'));
        }
      },
      (contractEmployeeDetail) {
        emit(ContractEmployeeLoaded(contractEmployeeDetail));
      },
    );
  }
}

abstract class ContractEmployeeState extends Equatable {
  const ContractEmployeeState();

  @override
  List<Object> get props => [];
}

class ContractEmployeeInitial extends ContractEmployeeState {}

class ContractEmployeeLoading extends ContractEmployeeState {}

class ContractEmployeeLoaded extends ContractEmployeeState {
  final ContractEmployeeDetail contractEmployeeDetail;

  const ContractEmployeeLoaded(this.contractEmployeeDetail);

  @override
  List<Object> get props => [contractEmployeeDetail];
}

class ContractEmployeeError extends ContractEmployeeState {
  final String message;

  const ContractEmployeeError(this.message);

  @override
  List<Object> get props => [message];
}
