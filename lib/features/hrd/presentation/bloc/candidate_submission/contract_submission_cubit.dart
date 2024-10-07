import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/contract_submission_detail_model.dart.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractSubmissionCubit extends Cubit<ContractSubmissionState> {
  final HRDRepository repository;

  ContractSubmissionCubit(this.repository) : super(ContractSubmissionInitial());

  Future<void> fetchContractSubmissionDetail(int candidateSubmissionId) async {
    emit(ContractSubmissionLoading());

    final result = await repository.getContractSubmissionDetail(candidateSubmissionId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(ContractSubmissionError(failure.message));
        } else {
          emit(ContractSubmissionError('Failed to fetch contract submission detail.'));
        }
      },
      (contractSubmissionDetail) {
        emit(ContractSubmissionLoaded(contractSubmissionDetail));
      },
    );
  }
}

abstract class ContractSubmissionState {}

class ContractSubmissionInitial extends ContractSubmissionState {}

class ContractSubmissionLoading extends ContractSubmissionState {}

class ContractSubmissionLoaded extends ContractSubmissionState {
  final ContractSubmissionDetail contractSubmissionDetail;

  ContractSubmissionLoaded(this.contractSubmissionDetail);
}

class ContractSubmissionError extends ContractSubmissionState {
  final String message;

  ContractSubmissionError(this.message);
}
