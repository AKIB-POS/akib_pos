import 'package:akib_pos/features/accounting/data/datasources/local/employee_shared_pref.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AttendanceRecapInteractionCubit extends Cubit<AttendanceRecapInteractionState> {
  final EmployeeSharedPref employeeSharedPref;

  AttendanceRecapInteractionCubit({required this.employeeSharedPref})
      : super(AttendanceRecapInteractionState(
            employeeName: employeeSharedPref.getEmployeeList().isNotEmpty
                ? employeeSharedPref.getEmployeeList()[0].employeeName
                : '',
            employeeId: employeeSharedPref.getEmployeeList().isNotEmpty
                ? employeeSharedPref.getEmployeeList()[0].employeeId
                : 0,
            selectedDate: DateFormat('yyyy-MM-dd').format(DateTime.now())));

  void selectEmployee(String employeeName) {
    final selectedEmployee = employeeSharedPref
        .getEmployeeList()
        .firstWhere((employee) => employee.employeeName == employeeName);

    emit(state.copyWith(
      employeeName: selectedEmployee.employeeName,
      employeeId: selectedEmployee.employeeId,
    ));
  }

  void selectDate(DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    emit(state.copyWith(selectedDate: formattedDate));
  }

  List<EmployeeModel> getEmployeeList() {
    return employeeSharedPref.getEmployeeList();
  }
}

class AttendanceRecapInteractionState {
  final String employeeName;
  final int employeeId;
  final String selectedDate;

  AttendanceRecapInteractionState({
    required this.employeeName,
    required this.employeeId,
    required this.selectedDate,
  });

  AttendanceRecapInteractionState copyWith({
    String? employeeName,
    int? employeeId,
    String? selectedDate,
  }) {
    return AttendanceRecapInteractionState(
      employeeName: employeeName ?? this.employeeName,
      employeeId: employeeId ?? this.employeeId,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
