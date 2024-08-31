import 'dart:convert';

class MemberModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String? email;

  MemberModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
  });

  // Factory constructor untuk membuat instance MemberModel dari JSON
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
    );
  }

  // Method untuk mengubah instance MemberModel menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
    };
  }

  // Optional: Method untuk mengonversi List of Members from JSON
  static List<MemberModel> fromJsonList(String jsonString) {
    final data = json.decode(jsonString) as List<dynamic>;
    return data.map((json) => MemberModel.fromJson(json)).toList();
  }

  // Optional: Method untuk mengonversi List of Members to JSON
  static String toJsonList(List<MemberModel> members) {
    final data = members.map((member) => member.toJson()).toList();
    return json.encode(data);
  }
}
