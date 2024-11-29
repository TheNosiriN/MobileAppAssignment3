import 'package:flutter/material.dart';
import 'db_helper.dart';

class QueryScreen extends StatefulWidget {
  @override
  _QueryScreenState createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> _orderPlans = [];

  // Query order plan by date
  void _queryOrderPlan() async {
    String date = _dateController.text;
    if (date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a date')));
      return;
    }
    List<Map<String, dynamic>>? orderPlans = await DbHelper.getOrderPlans(date);

    // Check if order plans are returned and parse food items
    setState(() {
      if (orderPlans!.isNotEmpty) {
        _orderPlans = orderPlans;
      } else {
        _orderPlans = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Query Order Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Enter Date (YYYY-MM-DD)'),
            ),
            ElevatedButton(
              onPressed: _queryOrderPlan,
              child: Text("Query Order Plan"),
            ),
            Expanded(
              child: _orderPlans.isEmpty
                  ? Center(child: Text('No food items available'))
                  : ListView.builder(
                itemCount: _orderPlans.length,
                itemBuilder: (context, index) {
                  final orderPlan = _orderPlans[index];
                  final foodItems = orderPlan['food_items'].split(',');
                  return ListTile(
                    title: Text("Date: ${orderPlan['date']}"),
                    subtitle: Text("Food Items: ${foodItems.join(', ')}"),
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
