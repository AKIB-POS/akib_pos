import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/settings/data/models/personal_information.dart';
import 'package:akib_pos/features/settings/data/repositories/setting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPersonalInformationCubit extends Cubit<GetPersonalInformationState> {
  final SettingRepository repository;

  GetPersonalInformationCubit(this.repository) : super(GetPersonalInformationInitial());

  Future<void> fetchPersonalInformation() async {
    emit(GetPersonalInformationLoading());

    final result = await repository.getPersonalInformation();

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(GetPersonalInformationError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(GetPersonalInformationError(failure.message));
        } else {
          emit(GetPersonalInformationError('Failed to fetch personal information.'));
        }
      },
      (personalInfoResponse) {
        emit(GetPersonalInformationLoaded(personalInfoResponse));
      },
    );
  }
}

abstract class GetPersonalInformationState {}

class GetPersonalInformationInitial extends GetPersonalInformationState {}

class GetPersonalInformationLoading extends GetPersonalInformationState {}

class GetPersonalInformationLoaded extends GetPersonalInformationState {
  final PersonalInformationResponse personalInfo;

  GetPersonalInformationLoaded(this.personalInfo);
}

class GetPersonalInformationError extends GetPersonalInformationState {
  final String message;

  GetPersonalInformationError(this.message);
}
