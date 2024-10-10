import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/di/accounting_injection.dart';
import 'package:akib_pos/di/hrd_injection.dart';
import 'package:akib_pos/di/injection_container.dart';
import 'package:akib_pos/di/stockist_injection.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/active_asset_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/asset_depreciation_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/pending_asset_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/sold_asset_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/cash_flow_report/cash_flow_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/cash_flow_report/date_range_cash_flow_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/date_range_expenditure_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/purchased_product_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/total_expenditure_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/date_range_financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/date_range_profit_loss_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/profit_loss_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/profit_loss_details_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/date_range_pruchase_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/purchase_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/total_purchase_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/date_range_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/sales_product_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/sales_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/service_charge_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/service_charge_setting_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/tax_management_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/tax_management_setting_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/employee_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/transaction_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/transaction_report_interaction_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_summary_cubit.dart';
import 'package:akib_pos/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/close_cashier/close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/expenditure/expenditure_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/open_cashier/open_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/post_close_cashier/post_close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/printer/printer_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/product/product_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/process_transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/checkout/checkout_cubit.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/hrd_all_employee.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/attendance_recap_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/attendance_recap_interaction_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/date_range_attendance_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/attendance_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_type_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/submit_leave_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_type_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/submit_overtime_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/check_in_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/check_out_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_type_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/submit_permission_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/contract_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/permanent_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/verify_candidate_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/administration/company_rules_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/administration/employee_sop_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/administration/employee_warning_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/contract_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/hrd_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/permanent_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/employee_performance_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/performance_metric_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/submit_employee_performance_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_training_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/salary/detail_salary_slip_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/salary/salary_slip_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/detail_employee_tasking_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/employee_task_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/finished_subordinate_task_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/submit_employee_tasking_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/unfinished_subordinate_task_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/verify_employee_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/hrd_subordinate_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/hrd_summary_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/detail_subordinate_task_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_submission/pending_approval_tab.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_equipment_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_material_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_raw_material_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_vendor.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/expired_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_detail_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_order_status_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_purchase_history_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_unit_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_vendor_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_warehouses_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/material_detail_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/running_out_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/stockist_recent_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/stockist_summary_cubit.dart';
import 'package:akib_pos/splash_screen.dart';
import 'package:akib_pos/util/bloc_providers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:akib_pos/di/injection_container.dart' as di;
import 'package:akib_pos/di/accounting_injection.dart' as accounting;
import 'package:akib_pos/di/hrd_injection.dart' as hrd;
import 'package:akib_pos/di/stockist_injection.dart' as stockist;
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- This line imports the initializeDateFormatting function

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('id', null);

  await _requestPermissions();
  //for auth and cashier injection initialization
  await di.init();
  //for accounting injection initialization
  await accounting.initAccountingModule();
  await hrd.initHRDModule();
  await stockist.initStockistModule();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            kasirRepository: sl(),
            localDataSource: sl(),
          )
            ..add(FetchCategoriesEvent())
            ..add(const FetchSubCategoriesEvent())
            ..add(FetchProductsEvent())
            ..add(const FetchAdditionsEvent())
            ..add(const FetchVariantsEvent()),
        ),
        BlocProvider(
          create: (context) => CashierCubit(
            localDataSource: sl(),
            productBloc: sl<ProductBloc>(),
          )..loadData(),
        ),
        BlocProvider(
            create: (context) =>
                TransactionCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                ProcessTransactionCubit()), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                VoucherCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                BadgeCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                CheckoutCubit(sl())), // Ensure this is provided here
        BlocProvider(create: (context) => MemberCubit(repository: sl())),
        BlocProvider(create: (context) => CloseCashierCubit(repository: sl())),
        BlocProvider(
            create: (context) => PostCloseCashierCubit(repository: sl())),
        BlocProvider(create: (context) => OpenCashierCubit(repository: sl())),
        BlocProvider(create: (context) => ExpenditureCubit(repository: sl())),
        BlocProvider(create: (context) => AuthCubit(sl())),
        BlocProvider(
            create: (context) =>
                PrinterCubit(bluetooth: sl(), sharedPreferences: sl())),

        //ACCOUNTING MODULE
        BlocProvider(
          create: (context) =>
              TransactionSummaryCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => EmployeeCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => TransactionReportInteractionCubit(
              employeeSharedPref: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              TransactionListCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              TransactionReportCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangeCubit(),
        ),
        BlocProvider(
          create: (context) =>
              SalesReportCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              SalesProductReportCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangePurchaseCubit(),
        ),
        BlocProvider(
          create: (context) =>
              TotalPurchaseCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              PurchaseListCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangeExpenditureCubit(),
        ),
        BlocProvider(
          create: (context) =>
              TotalExpenditureCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangeProfitLossCubit(),
        ),
        BlocProvider(
          create: (context) =>
              ProfitLossCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => ProfitLossDetailsCubit(),
        ),
        BlocProvider(
          create: (context) =>
              PurchasedProductCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangeCashFlowCubit(),
        ),
        BlocProvider(
          create: (context) =>
              CashFlowReportCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => PendingAssetCubit(accountingInjection()),
        ),
        BlocProvider(
          create: (context) => ActiveAssetCubit(accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              SoldAssetCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              AssetDepreciationCubit(repository: accountingInjection()),
        ),

        BlocProvider(
          create: (context) => DateRangeFinancialBalanceCubit(),
        ),
        BlocProvider(
          create: (context) =>
              FinancialBalanceCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              ServiceChargeCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              ServiceChargeSettingCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              TaxManagementCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) =>
              TaxManagementSettingCubit(repository: accountingInjection()),
        ),

        //HRD
        BlocProvider(
          create: (context) => HRDSummaryCubit(hrdInjection()),
        ),
    
        BlocProvider(
          create: (context) => HRDAllSubordinateEmployeeCubit(hrdInjection()),
        ),
    
        BlocProvider(
          create: (context) => CheckInCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => CheckOutCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => AttendanceHistoryCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => AttendanceRecapCubit(hrdInjection()),
        ),

        BlocProvider(
          create: (context) => DateRangeAttendanceCubit(),
        ),
        BlocProvider(
          create: (context) => AttendanceRecapInteractionCubit(employeeSharedPref: hrdInjection())),

        BlocProvider(
          create: (context) => LeaveQuotaCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => LeaveRequestCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => LeaveHistoryCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => SubmitLeaveRequestCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => LeaveTypeCubit(hrdInjection()),
        ),

        BlocProvider(
          create: (context) => PermissionQuotaCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => PermissionRequestCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => PermissionHistoryCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => PermissionTypeCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => SubmitPermissionRequestCubit(hrdInjection()),
        ),

        BlocProvider(
          create: (context) => OvertimeRequestCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => OvertimeHistoryCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => OvertimeTypeCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => SubmitOvertimeRequestCubit(hrdInjection()),
        ),


        BlocProvider(
          create: (context) => SalarySlipCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => DetailSalarySlipCubit(hrdInjection()),
        ),

        //Employee Service
        BlocProvider(
          create: (context) => HRDAllEmployeesCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => ContractEmployeeCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => PerformanceMetricCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => PermanentEmployeeCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => SubmitEmployeePerformanceCubit(hrdInjection()),
        ),
        //Administration
        BlocProvider(
          create: (context) => EmployeeWarningCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => EmployeeSOPCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => CompanyRulesCubit(hrdInjection()),
        ),
        //training
        BlocProvider(
          create: (context) => EmployeeTrainingCubit(hrdInjection()),
        ),
        //Tasking
        BlocProvider(
          create: (context) => EmployeeTaskCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => FinishedSubordinateTaskCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => UnfinishedSubordinateTaskCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => DetailSubordinateTaskCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => DetailEmployeeTaskCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => SubmitEmployeeTaskingCubit(hrdInjection()),
        ),
        

        //Employee Submission
        BlocProvider(
          create: (context) => PendingSubmissionsCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => ApprovedSubmissionsCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => RejectedSubmissionsCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => VerifyEmployeeSubmissionCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => EmployeePerformanceCubit(hrdInjection()),
        ),

        //Candidate Submission
        BlocProvider(
          create: (context) => CandidatePendingSubmissionsCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => CandidateApprovedSubmissionsCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => CandidateRejectedSubmissionsCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => ContractSubmissionCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => PermanentSubmissionCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => VerifyCandidateSubmissionCubit(hrdInjection()),
        ),
        BlocProvider(
          create: (context) => StockistSummaryCubit(hrdInjection()),
        ),


        //Stockist
        BlocProvider(
          create: (context) => StockistSummaryCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => StockistRecentPurchasesCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => ExpiredStockCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => RunningOutStockCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetVendorCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => AddVendorCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetRawMaterialTypeCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => AddRawMaterialCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => AddEquipmentTypeCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetRawMaterialPurchaseCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetMaterialDetailCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetPurchaseHistoryCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetUnitCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetWarehousesCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetOrderStatusCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => AddRawMaterialStockCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetEquipmentTypeCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetEquipmentPurchaseCubit(stockistInjection()),
        ),
        BlocProvider(
          create: (context) => GetEquipmentDetailCubit(stockistInjection()),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _requestPermissions() async {
  PermissionStatus bluetoothStatus = await Permission.bluetooth.status;
  PermissionStatus locationStatus = await Permission.location.status;

  if (!bluetoothStatus.isGranted) {
    await Permission.bluetooth.request();
  }

  if (!locationStatus.isGranted) {
    await Permission.location.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'AK Solutions',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor:
                  AppColors.primaryMain, // Warna kursor di seluruh aplikasi
              selectionColor: AppColors.primaryMain
                  .withOpacity(0.5), // Warna selection (highlight)
              selectionHandleColor:
                  AppColors.primaryMain, // Warna handle selection
            ),
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            primaryColor: AppColors.primaryMain,
            indicatorColor: AppColors.primaryMain,
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: AppColors.primaryMain, // Warna progress indicator
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
