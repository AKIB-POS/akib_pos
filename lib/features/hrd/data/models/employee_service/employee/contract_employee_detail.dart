class ContractEmployeeDetail {
  final String employeeType;
  final EmployeeInfo employeeInfo;
  final PersonalInfo personalInfo;

  ContractEmployeeDetail({
    required this.employeeType,
    required this.employeeInfo,
    required this.personalInfo,
  });

  factory ContractEmployeeDetail.fromJson(Map<String, dynamic> json) {
    return ContractEmployeeDetail(
      employeeType: json['employee_type'],
      employeeInfo: EmployeeInfo.fromJson(json['employee_info']),
      personalInfo: PersonalInfo.fromJson(json['personal_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_type': employeeType,
      'employee_info': employeeInfo.toJson(),
      'personal_info': personalInfo.toJson(),
    };
  }
}

class EmployeeInfo {
  final String? position;
  final String branch;
  final String contractStart;
  final String contractEnd;

  EmployeeInfo({
    required this.position,
    required this.branch,
    required this.contractStart,
    required this.contractEnd,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      position: json['position'],
      branch: json['branch'],
      contractStart: json['contract_start'],
      contractEnd: json['contract_end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'branch': branch,
      'contract_start': contractStart,
      'contract_end': contractEnd,
    };
  }
}

class PersonalInfo {
  final String name;
  final String gender;
  final String birthDate;
  final String phoneNumber;
  final String email;
  final String address;

  PersonalInfo({
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birth_date'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'birth_date': birthDate,
      'phone_number': phoneNumber,
      'email': email,
      'address': address,
    };
  }
}

