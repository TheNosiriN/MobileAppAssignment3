import 'package:flutter/material.dart';
import 'db_helper.dart';

class OrderPlanScreen extends StatefulWidget {
  @override
  _OrderPlanScreenState createState() => _OrderPlanScreenState();
}

class _OrderPlanScreenState extends State<OrderPlanScreen> {
  final _targetCostController = TextEditingController();
  final _dateController = TextEditingController();
  String selectedFoodItems = '';
  List<Map<String, dynamic>> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  _loadFoodItems() async {
    final foodItems = await DbHelper.getAllFoodItems();
    setState(() {
      _foodItems = foodItems;
    });
  }

  _saveOrderPlan() async {
    final date = _dateController.text;
    final targetCost = _targetCostController.text;
    final foodItems = selectedFoodItems;

    if (date.isNotEmpty && targetCost.isNotEmpty && foodItems.isNotEmpty) {
      await DbHelper.insertOrderPlan(date, targetCost, foodItems);
      _showSuccessMessage();
    } else {
      _showErrorMessage();
    }
  }

  _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order plan saved')));
  }

  _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
  }

  _onFoodItemSelected(String itemName) {
    setState(() {
      selectedFoodItems += itemName + ', ';
    });
  }

  double _calculateTotalCost() {
    double totalCost = 0.0;

    for (var item in selectedFoodItems.split(', ')) {
      final foodItem = _foodItems.firstWhere(
            (food) => food['name'] == item,
        orElse: () => {'cost': 0.0},
      );
      totalCost += foodItem['cost'] ?? 0.0;  // Default to 0 if cost is null
    }

    return totalCost;
  }

  bool _isCostValid() {
    final targetCost = _targetCostController.text;
    final targetCostParsed = double.tryParse(targetCost);
    return targetCostParsed != null && _calculateTotalCost() <= targetCostParsed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _targetCostController,
              decoration: InputDecoration(labelText: 'Target Cost'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Select Food Items:'),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = _foodItems[index];
                  return ListTile(
                    title: Text(foodItem['name']),
                    subtitle: Text('\$${foodItem['cost']}'),
                    onTap: () => _onFoodItemSelected(foodItem['name']),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _isCostValid() ? _saveOrderPlan : null,
              child: Text('Save Order Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
