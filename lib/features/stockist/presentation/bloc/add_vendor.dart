import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/add_vendor.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVendorCubit extends Cubit<AddVendorState> {
  final StockistRepository repository;

  AddVendorCubit(this.repository) : super(AddVendorInitial());

  Future<void> addVendor(AddVendorRequest request) async {
    emit(AddVendorLoading());

    final result = await repository.addVendor(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AddVendorError(failure.message));
        } else {
          emit(AddVendorError('Failed to add vendor.'));
        }
      },
      (addVendorResponse) {
        emit(AddVendorSuccess(addVendorResponse.message));
      },
    );
  }
}

abstract class AddVendorState {}

class AddVendorInitial extends AddVendorState {}

class AddVendorLoading extends AddVendorState {}

class AddVendorSuccess extends AddVendorState {
  final String message;

  AddVendorSuccess(this.message);
}

class AddVendorError extends AddVendorState {
  final String message;

  AddVendorError(this.message);
}
