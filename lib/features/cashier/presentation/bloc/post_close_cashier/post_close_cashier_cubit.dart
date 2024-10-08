import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/datasources/local/cashier_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/models/open_cashier_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'post_close_cashier_state.dart';

class PostCloseCashierCubit extends Cubit<PostCloseCashierState> {
  final KasirRepository repository;

  PostCloseCashierCubit({required this.repository}) : super(PostCloseCashierInitial());

  void postCloseCashier(OpenCashierRequest request) async {
    emit(PostCloseCashierLoading());
    final result = await repository.postCloseCashier(request);

    result.fold(
      (failure) {
        emit(PostCloseCashierError('Gagal menutup kasir'));
        resetState(); // Reset state setelah error
      },
      (response) async {
        
        emit(PostCloseCashierSuccess(response.message));
        
      },
    );
  }

  void resetState() {
    emit(PostCloseCashierInitial());
  }
}

