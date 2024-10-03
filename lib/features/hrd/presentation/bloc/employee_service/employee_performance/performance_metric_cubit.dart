import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/performance_metric_model.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PerformanceMetricCubit extends Cubit<PerformanceMetricState> {
  final HRDRepository repository;

  PerformanceMetricCubit(this.repository) : super(PerformanceMetricInitial());

  Future<void> fetchPerformanceMetrics() async {
    emit(PerformanceMetricLoading());

    final result = await repository.getPerformanceMetrics();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PerformanceMetricError(failure.message));
        } else {
          emit(PerformanceMetricError('Failed to fetch performance metrics.'));
        }
      },
      (metrics) {
        emit(PerformanceMetricLoaded(metrics));
      },
    );
  }
}

abstract class PerformanceMetricState extends Equatable {
  const PerformanceMetricState();

  @override
  List<Object> get props => [];
}

class PerformanceMetricInitial extends PerformanceMetricState {}

class PerformanceMetricLoading extends PerformanceMetricState {}

class PerformanceMetricLoaded extends PerformanceMetricState {
  final List<PerformanceMetricModel> metrics;

  const PerformanceMetricLoaded(this.metrics);

  @override
  List<Object> get props => [metrics];
}

class PerformanceMetricError extends PerformanceMetricState {
  final String message;

  const PerformanceMetricError(this.message);

  @override
  List<Object> get props => [message];
}