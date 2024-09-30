import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/submit_permission_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


class SubmitPermissionRequestCubit extends Cubit<SubmitPermissionRequestState> {
  final HRDRepository repository;

  SubmitPermissionRequestCubit(this.repository) : super(SubmitPermissionRequestInitial());

  Future<void> submitPermissionRequest(SubmitPermissionRequest request) async {
    emit(SubmitPermissionRequestLoading());

    try {
      await repository.submitPermissionRequest(request);
      emit(SubmitPermissionRequestSuccess());
    } catch (e) {
      emit(SubmitPermissionRequestError(e.toString()));
    }
  }
}

abstract class SubmitPermissionRequestState extends Equatable {
  const SubmitPermissionRequestState();

  @override
  List<Object?> get props => [];
}

class SubmitPermissionRequestInitial extends SubmitPermissionRequestState {}

class SubmitPermissionRequestLoading extends SubmitPermissionRequestState {}

class SubmitPermissionRequestSuccess extends SubmitPermissionRequestState {}

class SubmitPermissionRequestError extends SubmitPermissionRequestState {
  final String message;

  const SubmitPermissionRequestError(this.message);

  @override
  List<Object?> get props => [message];
}
