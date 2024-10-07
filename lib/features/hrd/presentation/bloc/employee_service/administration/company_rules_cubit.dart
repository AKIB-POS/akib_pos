
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/employee_rules.dart';

import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyRulesCubit extends Cubit<CompanyRulesState> {
  final HRDRepository repository;

  CompanyRulesCubit(this.repository) : super(CompanyRulesInitial());

  Future<void> fetchCompanyRules() async {
    emit(CompanyRulesLoading());

    final result = await repository.getCompanyRules();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(CompanyRulesError(failure.message));
        } else {
          emit(CompanyRulesError('Failed to fetch company rules.'));
        }
      },
      (companyRules) {
        emit(CompanyRulesLoaded(companyRules));
      },
    );
  }
}

abstract class CompanyRulesState extends Equatable {
  const CompanyRulesState();

  @override
  List<Object> get props => [];
}

class CompanyRulesInitial extends CompanyRulesState {}

class CompanyRulesLoading extends CompanyRulesState {}

class CompanyRulesLoaded extends CompanyRulesState {
  final CompanyRulesResponse companyRulesResponse;

  const CompanyRulesLoaded(this.companyRulesResponse);

  @override
  List<Object> get props => [companyRulesResponse];
}

class CompanyRulesError extends CompanyRulesState {
  final String message;

  const CompanyRulesError(this.message);

  @override
  List<Object> get props => [message];
}