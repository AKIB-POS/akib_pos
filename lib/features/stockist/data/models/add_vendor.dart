class AddVendorRequest {
  final int branchId;
  final String vendorName;
  final String phoneNumber;
  final String address;

  AddVendorRequest({
    required this.branchId,
    required this.vendorName,
    required this.phoneNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'vendor_name': vendorName,
      'phone_number': phoneNumber,
      'address': address,
    };
  }
}

class AddVendorResponse {
  final String message;
  final String status;

  AddVendorResponse({
    required this.message,
    required this.status,
  });

  factory AddVendorResponse.fromJson(Map<String, dynamic> json) {
    return AddVendorResponse(
      message: json['message'],
      status: json['status'],
    );
  }
}
