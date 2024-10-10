import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment_detail.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEquipmentDetailCubit extends Cubit<GetEquipmentDetailState> {
  final StockistRepository repository;

  GetEquipmentDetailCubit(this.repository) : super(GetEquipmentDetailInitial());

  Future<void> fetchEquipmentDetail({required int branchId, required int equipmentId}) async {
    emit(GetEquipmentDetailLoading());

    final result = await repository.getEquipmentDetail(branchId, equipmentId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetEquipmentDetailError(failure.message));
        } else {
          emit(GetEquipmentDetailError('Failed to fetch equipment details.'));
        }
      },
      (equipmentDetailResponse) {
        emit(GetEquipmentDetailLoaded(equipmentDetailResponse.equipmentDetail));
      },
    );
  }
}

abstract class GetEquipmentDetailState {}

class GetEquipmentDetailInitial extends GetEquipmentDetailState {}

class GetEquipmentDetailLoading extends GetEquipmentDetailState {}

class GetEquipmentDetailLoaded extends GetEquipmentDetailState {
  final EquipmentDetail equipmentDetail;

  GetEquipmentDetailLoaded(this.equipmentDetail);
}

class GetEquipmentDetailError extends GetEquipmentDetailState {
  final String message;

  GetEquipmentDetailError(this.message);
}

