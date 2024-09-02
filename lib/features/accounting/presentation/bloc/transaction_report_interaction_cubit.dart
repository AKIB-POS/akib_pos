import 'package:akib_pos/features/accounting/data/datasources/local/employee_shared_pref.dart';
import 'package:akib_pos/features/accounting/data/models/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum CustomerTransactionType {
  top10,
  discount,
}

class TransactionReportInteractionCubit extends Cubit<TransactionReportInteractionState> {
  final EmployeeSharedPref employeeSharedPref;

  TransactionReportInteractionCubit({required this.employeeSharedPref})
      : super(TransactionReportInteractionState(
            employeeName: employeeSharedPref.getEmployeeList().isNotEmpty
                ? employeeSharedPref.getEmployeeList()[0].employeeName
                : '',
            employeeId: employeeSharedPref.getEmployeeList().isNotEmpty
                ? employeeSharedPref.getEmployeeList()[0].employeeId
                : 0,
            selectedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            selectedTransactionType: CustomerTransactionType.top10));

  void selectEmployee(String employeeName) {
    final selectedEmployee = employeeSharedPref
        .getEmployeeList()
        .firstWhere((employee) => employee.employeeName == employeeName);

    emit(state.copyWith(
      employeeName: selectedEmployee.employeeName,
      employeeId: selectedEmployee.employeeId,
    ));
  }
  void selectTransactionType(CustomerTransactionType type) {
    emit(state.copyWith(selectedTransactionType: type));
  }

  void selectDate(DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    emit(state.copyWith(selectedDate: formattedDate));
  }

  List<EmployeeModel> getEmployeeList() {
    return employeeSharedPref.getEmployeeList();
  }
}

class TransactionReportInteractionState {
  final String employeeName;
  final int employeeId;
  final String selectedDate;
  final CustomerTransactionType selectedTransactionType;

  TransactionReportInteractionState({
    required this.employeeName,
    required this.employeeId,
    required this.selectedDate,
    required this.selectedTransactionType,
  });

  TransactionReportInteractionState copyWith({
    String? employeeName,
    int? employeeId,
    String? selectedDate,
    CustomerTransactionType? selectedTransactionType,
  }) {
    return TransactionReportInteractionState(
      employeeName: employeeName ?? this.employeeName,
      employeeId: employeeId ?? this.employeeId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTransactionType: selectedTransactionType ?? this.selectedTransactionType,
    );
  }
}
