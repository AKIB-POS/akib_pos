import 'package:akib_pos/features/cashier/data/models/close_cashier_response.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'close_cashier_state.dart';

class CloseCashierCubit extends Cubit<CloseCashierState> {
  final KasirRepository repository;

  CloseCashierCubit({required this.repository}) : super(CloseCashierInitial());

  Future<void> closeCashier() async {
    emit(CloseCashierLoading());
    final result = await repository.closeCashier();
    result.fold(
      (failure) => emit(CloseCashierError("Failed to close cashier")),
      (data) => emit(CloseCashierLoaded(data)),
    );
  }
}