class PersonalInformation {
  final String name;
  final String email;
  final String? phoneNumber;

  PersonalInformation({
    required this.name,
    required this.email,
    this.phoneNumber,
  });

  factory PersonalInformation.fromJson(Map<String, dynamic> json) {
    return PersonalInformation(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],  // Bisa null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}

class EmployeeInformation {
  final String position;
  final String gender;
  final String birthDate;
  final String address;
  final String outlet;
  final String? startContract;  // Bisa null
  final String? endContract;    // Bisa null
  final String? determinationDate;  // Bisa null
  final String? skNumber;       // Bisa null

  EmployeeInformation({
    required this.position,
    required this.gender,
    required this.birthDate,
    required this.address,
    required this.outlet,
    this.startContract,      // Null untuk SK employee
    this.endContract,        // Null untuk SK employee
    this.determinationDate,  // Null untuk kontrak employee
    this.skNumber,           // Null untuk kontrak employee
  });

  factory EmployeeInformation.fromJson(Map<String, dynamic> json) {
    return EmployeeInformation(
      position: json['position'],
      gender: json['gender'],
      birthDate: json['birth_date'],
      address: json['address'],
      outlet: json['outlet'],
      // Tangani start_contract dan end_contract jika ada
      startContract: json['start_contract'],
      endContract: json['end_contract'],
      // Tangani determination_date dan sk_number jika ada
      determinationDate: json['determination_date'],
      skNumber: json['sk_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'gender': gender,
      'birth_date': birthDate,
      'address': address,
      'outlet': outlet,
      'start_contract': startContract,  // Bisa null
      'end_contract': endContract,      // Bisa null
      'determination_date': determinationDate,  // Bisa null
      'sk_number': skNumber,            // Bisa null
    };
  }
}

class PersonalInformationResponse {
  final PersonalInformation personalInformation;
  final EmployeeInformation? employeeInformation;

  PersonalInformationResponse({
    required this.personalInformation,
    this.employeeInformation,
  });

  factory PersonalInformationResponse.fromJson(Map<String, dynamic> json) {
    return PersonalInformationResponse(
      personalInformation: PersonalInformation.fromJson(json['personal_information']),
      employeeInformation: json['employee_information'] != null
          ? EmployeeInformation.fromJson(json['employee_information'])
          : null,  // Bisa null jika tidak ada employee_information
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personal_information': personalInformation.toJson(),
      'employee_information': employeeInformation?.toJson(),  // Bisa null
    };
  }
}
