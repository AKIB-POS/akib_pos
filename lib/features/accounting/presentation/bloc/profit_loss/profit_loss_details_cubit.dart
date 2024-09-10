import 'package:flutter_bloc/flutter_bloc.dart';

class ProfitLossDetailsCubit extends Cubit<ProfitLossDetailsState> {
  ProfitLossDetailsCubit() : super(ProfitLossDetailsState(isDetailsVisible: false));

  void toggleDetailsVisibility() {
    emit(state.copyWith(isDetailsVisible: !state.isDetailsVisible));
  }
}

class ProfitLossDetailsState {
  final bool isDetailsVisible;

  ProfitLossDetailsState({required this.isDetailsVisible});

  ProfitLossDetailsState copyWith({bool? isDetailsVisible}) {
    return ProfitLossDetailsState(
      isDetailsVisible: isDetailsVisible ?? this.isDetailsVisible,
    );
  }
}
