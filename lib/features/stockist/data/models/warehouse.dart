class Warehouse {
  final int warehouseId;
  final String warehouseName;

  Warehouse({required this.warehouseId, required this.warehouseName});

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      warehouseId: json['warehouse_id'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouse_id': warehouseId,
      'warehouse_name': warehouseName,
    };
  }
}

class GetWarehousesResponse {
  final List<Warehouse> warehouses;

  GetWarehousesResponse({required this.warehouses});

  factory GetWarehousesResponse.fromJson(Map<String, dynamic> json) {
    var warehouses = (json['data'] as List)
        .map((warehouse) => Warehouse.fromJson(warehouse))
        .toList();
    return GetWarehousesResponse(warehouses: warehouses);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': warehouses.map((warehouse) => warehouse.toJson()).toList(),
    };
  }
}
