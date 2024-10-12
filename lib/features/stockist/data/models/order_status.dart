class OrderStatus {
  final int id;
  final String name;

  OrderStatus({required this.id, required this.name});

  // Factory method to create an instance from JSON
  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json['order_status_id'],
      name: json['order_status_name'],
    );
  }
}

class OrderStatusResponse {
  final List<OrderStatus> statuses;

  OrderStatusResponse({required this.statuses});

  // Factory method to create an instance from JSON
  factory OrderStatusResponse.fromJson(Map<String, dynamic> json) {
    var statuses = (json['data'] as List)
        .map((status) => OrderStatus.fromJson(status))
        .toList();
    return OrderStatusResponse(statuses: statuses);
  }
}
