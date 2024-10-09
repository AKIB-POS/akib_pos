import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/order_status.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetOrderStatusCubit extends Cubit<GetOrderStatusState> {
  final StockistRepository repository;

  GetOrderStatusCubit(this.repository) : super(GetOrderStatusInitial());

  Future<void> fetchOrderStatuses({required int branchId}) async {
    emit(GetOrderStatusLoading());

    final result = await repository.getOrderStatuses(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetOrderStatusError(failure.message));
        } else {
          emit(GetOrderStatusError('Failed to fetch order statuses.'));
        }
      },
      (orderStatusResponse) {
        emit(GetOrderStatusLoaded(orderStatusResponse.statuses));
      },
    );
  }
}
abstract class GetOrderStatusState {}

class GetOrderStatusInitial extends GetOrderStatusState {}

class GetOrderStatusLoading extends GetOrderStatusState {}

class GetOrderStatusLoaded extends GetOrderStatusState {
  final List<OrderStatus> statuses;

  GetOrderStatusLoaded(this.statuses);
}

class GetOrderStatusError extends GetOrderStatusState {
  final String message;

  GetOrderStatusError(this.message);
}

