import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/vendor.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetVendorCubit extends Cubit<GetVendorState> {
  final StockistRepository repository;

  GetVendorCubit(this.repository) : super(GetVendorInitial());

  Future<void> fetchVendors({required int branchId}) async {
    emit(GetVendorLoading());

    final result = await repository.getVendors(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetVendorError(failure.message));
        } else {
          emit(GetVendorError('Failed to fetch vendors.'));
        }
      },
      (vendorList) {
        emit(GetVendorLoaded(vendorList));
      },
    );
  }
}

abstract class GetVendorState {}

class GetVendorInitial extends GetVendorState {}

class GetVendorLoading extends GetVendorState {}

class GetVendorLoaded extends GetVendorState {
  final VendorListResponse vendorList;

  GetVendorLoaded(this.vendorList);
}

class GetVendorError extends GetVendorState {
  final String message;

  GetVendorError(this.message);
}
