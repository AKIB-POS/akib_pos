import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CashierModeCubit extends Cubit<String> {
  CashierModeCubit() : super('portrait');

  void setMode(String mode) {
    emit(mode);
    if (mode == 'landscape') {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    }
  }

  @override
  Future<void> close() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return super.close();
  }
}