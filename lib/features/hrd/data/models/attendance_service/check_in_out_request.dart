class CheckInOutRequest {
  final String time;
  final double lat;
  final double long;

  CheckInOutRequest({
    required this.time,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'lat': lat,
      'long': long,
    };
  }
}


class CheckInOutResponse {
  final String message;

  CheckInOutResponse({required this.message});

  factory CheckInOutResponse.fromJson(Map<String, dynamic> json) {
    return CheckInOutResponse(
      message: json['message'],
    );
  }
}
