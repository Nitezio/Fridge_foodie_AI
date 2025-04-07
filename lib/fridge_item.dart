class FridgeItem {
  String name;
  DateTime expiryDate;
  double? quantity;
  String? unit;
  String? category;

  FridgeItem({
    required this.name,
    required this.expiryDate,
    this.quantity,
    this.unit,
    this.category,
  });

  factory FridgeItem.fromJson(Map<String, dynamic> json) {
    return FridgeItem(
      name: json['name'],
      expiryDate: DateTime.parse(json['expiryDate']),
      quantity: json['quantity']?.toDouble(),
      unit: json['unit'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'expiryDate': expiryDate.toIso8601String(),
      'quantity': quantity,
      'unit': unit,
      'category': category,
    };
  }
}