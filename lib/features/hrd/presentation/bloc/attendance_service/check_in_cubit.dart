import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

// CheckInCubit
class CheckInCubit extends Cubit<CheckInState> {
  final HRDRepository repository;

  CheckInCubit(this.repository) : super(CheckInInitial());

  Future<void> checkIn() async {
    emit(CheckInLoading());

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

      final result = await repository.checkIn(request);

      result.fold(
        (failure) {
          if (failure is GeneralFailure) {
            emit(CheckInError(failure.message));
          } else {
            emit(CheckInError('Failed to check in.'));
          }
        },
        (response) {
          emit(CheckInSuccess(response.message));
        },
      );
    } catch (e) {
      emit(CheckInError('Failed to check in: ${e.toString()}'));
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
abstract class CheckInState {}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInSuccess extends CheckInState {
  final String message;

  CheckInSuccess(this.message);
}

class CheckInError extends CheckInState {
  final String message;

  CheckInError(this.message);
}