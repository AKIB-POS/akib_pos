import 'package:akib_pos/features/hrd/data/datasources/remote/hrd_remote_data_source.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/attendance_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_summary_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/check_in_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/check_out_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_quota_cubit.dart';
import 'package:get_it/get_it.dart';

final hrdInjection = GetIt.instance;

Future<void> initHRDModule() async {
  //! Features - HRD
  // Remote Data Source
  hrdInjection.registerLazySingleton<HRDRemoteDataSource>(
    () => HRDRemoteDataSourceImpl(client: hrdInjection()),
  );

  // Repository
  hrdInjection.registerLazySingleton<HRDRepository>(
    () => HRDRepositoryImpl(remoteDataSource: hrdInjection()),
  );

  // Cubits
  hrdInjection.registerFactory(
    () => AttendanceSummaryCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => CheckInCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => CheckOutCubit(hrdInjection()),
  );

    hrdInjection.registerFactory(
    () => AttendanceHistoryCubit(hrdInjection()),
  );

  hrdInjection.registerFactory(
    () => LeaveQuotaCubit(hrdInjection()), // Register the LeaveQuotaCubit
  );

   hrdInjection.registerFactory(
    () => LeaveRequestCubit(hrdInjection()), // Register the LeaveRequestCubit
  );

}