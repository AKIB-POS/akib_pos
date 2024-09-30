import 'package:akib_pos/features/hrd/data/datasources/remote/hrd_remote_data_source.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/candidate_submission.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/attendance_recap_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/attendance_recap_interaction_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/attendance_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_type_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/submit_leave_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_request)cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/check_in_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/check_out_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/contract_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/permanent_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/verify_candidate_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/administration/employee_sop_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/administration/employee_warning_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/contract_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/hrd_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/permanent_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/employee_performance_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/submit_employee_performance_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_training_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/salary/detail_salary_slip_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/salary/salary_slip_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/verify_employee_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/hrd_summary_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/rejected_submission_cubit.dart';
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
    () => HRDSummaryCubit(hrdInjection()),
  );
  //attendance

  hrdInjection.registerFactory(
    () => AttendanceRecapInteractionCubit(employeeSharedPref: hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => AttendanceRecapCubit(hrdInjection()),
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

  hrdInjection.registerFactory(
    () => LeaveHistoryCubit(hrdInjection()), // Register the LeaveHistoryCubit
  );
  hrdInjection.registerFactory(
    () => SubmitLeaveRequestCubit(hrdInjection()), // Register the LeaveHistoryCubit
  );
   hrdInjection.registerFactory(
    () => LeaveTypeCubit(hrdInjection()),
  );

  hrdInjection.registerFactory(
    () => PermissionQuotaCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => PermissionRequestCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => PermissionHistoryCubit(hrdInjection()),
  );

  hrdInjection.registerFactory(
    () => OvertimeRequestCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => OvertimeHistoryCubit(hrdInjection()),
  );

  //Salary
  hrdInjection.registerFactory(
    () => SalarySlipCubit(hrdInjection()),
  );

  hrdInjection.registerFactory(
    () => DetailSalarySlipCubit(hrdInjection()),
  );

  //Employee
  hrdInjection.registerFactory(
    () => HRDAllEmployeesCubit(hrdInjection()),
  );
   // Contract Employee Cubit
  hrdInjection.registerFactory(
    () => ContractEmployeeCubit(hrdInjection()),
  );
  // Permanent Employee Cubit
  hrdInjection.registerFactory(
    () => PermanentEmployeeCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => EmployeePerformanceCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => SubmitEmployeePerformanceCubit(hrdInjection()),
  );
  //administration
   hrdInjection.registerFactory(
    () => EmployeeWarningCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => EmployeeSOPCubit(hrdInjection()),
  );
  //training
  hrdInjection.registerFactory(
    () => EmployeeTrainingCubit(hrdInjection()),
  );

  

  //Employee Submission
  hrdInjection.registerFactory(
    () => PendingSubmissionsCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => ApprovedSubmissionsCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => RejectedSubmissionsCubit(hrdInjection()),
  );

 

  // Register the cubit
  hrdInjection.registerFactory(
    () => VerifyEmployeeSubmissionCubit(hrdInjection()),
  );

  //candiate submission
  // Cubits
  hrdInjection.registerFactory(
    () => CandidatePendingSubmissionsCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => CandidateApprovedSubmissionsCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(
    () => CandidateRejectedSubmissionsCubit(hrdInjection()),
  );
  hrdInjection.registerFactory(() => ContractSubmissionCubit(hrdInjection()));
  hrdInjection.registerFactory(() => PermanentSubmissionCubit(hrdInjection()));
  hrdInjection.registerFactory(() => VerifyCandidateSubmissionCubit(hrdInjection()));
  
}
