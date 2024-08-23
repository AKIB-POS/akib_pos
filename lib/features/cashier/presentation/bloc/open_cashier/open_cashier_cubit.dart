import 'package:akib_pos/features/cashier/data/models/open_cashier_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

class OpenCashierCubit extends Cubit<OpenCashierState> {
  final KasirRepository repository;

  OpenCashierCubit({required this.repository}) : super(OpenCashierInitial());

  void openCashier(OpenCashierRequest request) async {
    emit(OpenCashierLoading());
    final result = await repository.openCashier(request);

    result.fold(
      (failure) => emit(OpenCashierError('Gagal membuka kasir')),
      (response) => emit(OpenCashierSuccess(response.message)),
    );
  }
}

abstract class OpenCashierState {}

class OpenCashierInitial extends OpenCashierState {}

class OpenCashierLoading extends OpenCashierState {}

class OpenCashierSuccess extends OpenCashierState {
  final String message;
  OpenCashierSuccess(this.message);
}

class OpenCashierError extends OpenCashierState {
  final String message;
  OpenCashierError(this.message);
}
