class MaterialItem {
  String id;
  String materialName;
  double quantity;
  String unit;
  String supplier;
  double totalCost;
  String status;

  MaterialItem({
    required this.id,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.supplier,
    required this.totalCost,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'materialName': materialName, 'quantity': quantity,
    'unit': unit, 'supplier': supplier, 'totalCost': totalCost, 'status': status,
  };

  factory MaterialItem.fromJson(Map<String, dynamic> json) => MaterialItem(
    id: json['id'], materialName: json['materialName'],
    quantity: (json['quantity'] as num).toDouble(),
    unit: json['unit'], supplier: json['supplier'],
    totalCost: (json['totalCost'] as num).toDouble(),
    status: json['status'],
  );
}
