class Vendor {
  final String vendorName;
  final String phoneNumber;
  final String address;

  Vendor({
    required this.vendorName,
    required this.phoneNumber,
    required this.address,
  });

  // Factory constructor for creating an instance from JSON
  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorName: json['vendor_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'vendor_name': vendorName,
      'phone_number': phoneNumber,
      'address': address,
    };
  }
}

class VendorListResponse {
  final List<Vendor> vendors;

  VendorListResponse({required this.vendors});

  // Factory constructor for creating an instance from JSON
  factory VendorListResponse.fromJson(Map<String, dynamic> json) {
    var vendorList = (json['data'] as List)
        .map((vendor) => Vendor.fromJson(vendor))
        .toList();
    return VendorListResponse(vendors: vendorList);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': vendors.map((vendor) => vendor.toJson()).toList(),
    };
  }
}
