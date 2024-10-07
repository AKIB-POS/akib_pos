import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip_detail.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailSalarySlipCubit extends Cubit<DetailSalarySlipState> {
  final HRDRepository repository;

  DetailSalarySlipCubit(this.repository) : super(DetailSalarySlipInitial());

  Future<void> fetchDetailSalarySlip(int month, int year) async {
    emit(DetailSalarySlipLoading());

    final result = await repository.getSalarySlipDetail(month,year);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(DetailSalarySlipError(failure.message));
        } else {
          emit(DetailSalarySlipError('Failed to fetch salary slip detail.'));
        }
      },
      (salarySlipDetail) {
        emit(DetailSalarySlipLoaded(salarySlipDetail));
      },
    );
  }
}

abstract class DetailSalarySlipState extends Equatable {
  const DetailSalarySlipState();

  @override
  List<Object> get props => [];
}

class DetailSalarySlipInitial extends DetailSalarySlipState {}

class DetailSalarySlipLoading extends DetailSalarySlipState {}

class DetailSalarySlipLoaded extends DetailSalarySlipState {
  final SalarySlipDetail salarySlipDetail;

  const DetailSalarySlipLoaded(this.salarySlipDetail);

  @override
  List<Object> get props => [salarySlipDetail];
}

class DetailSalarySlipError extends DetailSalarySlipState {
  final String message;

  const DetailSalarySlipError(this.message);

  @override
  List<Object> get props => [message];
}