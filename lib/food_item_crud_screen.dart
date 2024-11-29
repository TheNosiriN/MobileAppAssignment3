import 'package:flutter/material.dart';
import 'db_helper.dart';

class FoodItemCrudScreen extends StatefulWidget {
  @override
  _FoodItemCrudScreenState createState() => _FoodItemCrudScreenState();
}

class _FoodItemCrudScreenState extends State<FoodItemCrudScreen> {
  final _nameController = TextEditingController();
  final _costController = TextEditingController();

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

  _addFoodItem() async {
    final name = _nameController.text;
    final cost = double.tryParse(_costController.text) ?? 0.0;
    if (name.isNotEmpty && cost > 0.0) {
      await DbHelper.insertFoodItem(name, cost);
      _loadFoodItems();
    }
  }

  _updateFoodItem(int id) async {
    final name = _nameController.text;
    final cost = double.tryParse(_costController.text) ?? 0.0;
    if (name.isNotEmpty && cost > 0.0) {
      await DbHelper.updateFoodItem(id, name, cost);
      _loadFoodItems();
    }
  }

  _deleteFoodItem(int id) async {
    await DbHelper.deleteFoodItem(id);
    _loadFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Item CRUD')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addFoodItem,
                  child: Text('Add Food Item'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_foodItems.isNotEmpty) {
                      _updateFoodItem(_foodItems[0]['id']); // Example: Update first food item
                    }
                  },
                  child: Text('Update Food Item'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = _foodItems[index];
                  return ListTile(
                    title: Text(foodItem['name']),
                    subtitle: Text('\$${foodItem['cost']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteFoodItem(foodItem['id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
