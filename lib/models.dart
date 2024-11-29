class FoodItem {
  final int? id;
  final String name;
  final double cost;

  FoodItem({this.id, required this.name, required this.cost});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'cost': cost};
  }

  static FoodItem fromMap(Map<String, dynamic> map) {
    return FoodItem(id: map['id'], name: map['name'], cost: map['cost']);
  }
}

class OrderPlan {
  final int? id;
  final String date;
  final double targetCost;
  final String selectedItems;

  OrderPlan({this.id, required this.date, required this.targetCost, required this.selectedItems});

  Map<String, Object?> toMap() {
    return {'id': id, 'date': date, 'target_cost': targetCost, 'selected_items': selectedItems};
  }

  static OrderPlan fromMap(Map<String, dynamic> map) {
    return OrderPlan(
        id: map['id'],
        date: map['date'],
        targetCost: map['target_cost'],
        selectedItems: map['selected_items']);
  }
}
