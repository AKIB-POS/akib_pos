import 'package:flutter_bloc/flutter_bloc.dart';

class ProcessTransactionState {
  final bool isDetailsVisible;

  ProcessTransactionState({required this.isDetailsVisible});

  ProcessTransactionState copyWith({bool? isDetailsVisible}) {
    return ProcessTransactionState(
      isDetailsVisible: isDetailsVisible ?? this.isDetailsVisible,
    );
  }
}

class ProcessTransactionCubit extends Cubit<ProcessTransactionState> {
  ProcessTransactionCubit() : super(ProcessTransactionState(isDetailsVisible: true));

  void toggleDetailsVisibility() {
    emit(state.copyWith(isDetailsVisible: !state.isDetailsVisible));
  }
}
