import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/dashboard/data/models/branch.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class GetBranchesCubit extends Cubit<GetBranchesState> {
  final DashboardRepository repository;

  GetBranchesCubit(this.repository) : super(GetBranchesInitial());

  Future<void> fetchBranches() async {
    emit(GetBranchesLoading());

    final result = await repository.getBranches();

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(GetBranchesError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(GetBranchesError(failure.message));
        } else {
          emit(GetBranchesError('Failed to fetch branches.'));
        }
      },
      (branchesResponse) {
        emit(GetBranchesLoaded(branchesResponse));
      },
    );
  }
}


abstract class GetBranchesState {}

class GetBranchesInitial extends GetBranchesState {}

class GetBranchesLoading extends GetBranchesState {}

class GetBranchesLoaded extends GetBranchesState {
  final BranchesResponse branchesResponse;

  GetBranchesLoaded(this.branchesResponse);
}

class GetBranchesError extends GetBranchesState {
  final String message;

  GetBranchesError(this.message);
}

