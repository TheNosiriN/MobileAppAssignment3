import 'package:flutter/material.dart';
import 'food_item_crud_screen.dart';
import 'order_plan_screen.dart';
import 'query_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Ordering App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPlanScreen()),
                );
              },
              child: Text("Create Order Plan"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodItemCrudScreen()),
                );
              },
              child: Text("Manage Food Items"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QueryScreen()),
                );
              },
              child: Text("Query Order Plan"),
            ),
          ],
        ),
      ),
    );
  }
}
