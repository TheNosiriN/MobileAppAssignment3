import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'food_item_crud_screen.dart';
import 'order_plan_screen.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/food_item_crud': (context) => FoodItemCrudScreen(),
        '/order_plan': (context) => OrderPlanScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Ordering App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/food_item_crud');
              },
              child: Text('Manage Food Items'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/order_plan');
              },
              child: Text('Create Order Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
