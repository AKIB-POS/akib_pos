// CheckOutCubit
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  final HRDRepository repository;

  CheckOutCubit(this.repository) : super(CheckOutInitial());

  Future<void> checkOut() async {
    emit(CheckOutLoading());

    try {
      // Time-consuming operations start here
      final time = DateFormat('HH:mm').format(DateTime.now());
      final position = await _getCurrentLocation();
      final lat = position.latitude;
      final long = position.longitude;

      final request = CheckInOutRequest(
        time: time,
        lat: lat,
        long: long,
      );

      final result = await repository.checkOut(request);

      result.fold(
        (failure) {
          if (failure is GeneralFailure) {
            emit(CheckOutError(failure.message));
          } else {
            emit(CheckOutError('Failed to check out.'));
          }
        },
        (response) {
          emit(CheckOutSuccess(response.message));
        },
      );
    } catch (e) {
      emit(CheckOutError('Failed to check out: ${e.toString()}'));
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permissions
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition();
  }
}

// State classes remain the same
abstract class CheckOutState {}

class CheckOutInitial extends CheckOutState {}

class CheckOutLoading extends CheckOutState {}

class CheckOutSuccess extends CheckOutState {
  final String message;

  CheckOutSuccess(this.message);
}

class CheckOutError extends CheckOutState {
  final String message;

  CheckOutError(this.message);
}
