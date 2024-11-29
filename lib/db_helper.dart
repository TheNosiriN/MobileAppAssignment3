import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_ordering.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE food_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            cost REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE order_plans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            target_cost TEXT,
            food_items TEXT
          )
        ''');

        // Insert 20 initial food items
        await _insertInitialFoodItems(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE order_plans ADD COLUMN target_cost TEXT
          ''');
        }
      },
    );
  }

  static Future<void> _insertInitialFoodItems(Database db) async {
    List<Map<String, dynamic>> foodItems = [
      {'name': 'Pizza', 'cost': 9.99},
      {'name': 'Burger', 'cost': 5.99},
      {'name': 'Pasta', 'cost': 7.99},
      {'name': 'Sushi', 'cost': 12.99},
      {'name': 'Tacos', 'cost': 3.99},
      {'name': 'Salad', 'cost': 4.99},
      {'name': 'Sandwich', 'cost': 6.99},
      {'name': 'Fries', 'cost': 2.99},
      {'name': 'Soup', 'cost': 3.49},
      {'name': 'Hot Dog', 'cost': 2.49},
      {'name': 'Curry', 'cost': 8.99},
      {'name': 'Steak', 'cost': 14.99},
      {'name': 'Fried Chicken', 'cost': 11.99},
      {'name': 'Pizza Slice', 'cost': 3.99},
      {'name': 'Ice Cream', 'cost': 4.49},
      {'name': 'Milkshake', 'cost': 5.49},
      {'name': 'Pancakes', 'cost': 6.49},
      {'name': 'Bagel', 'cost': 2.99},
      {'name': 'Donuts', 'cost': 1.99},
      {'name': 'Burrito', 'cost': 7.49},
    ];

    // Insert each food item into the database
    for (var foodItem in foodItems) {
      await db.insert(
        'food_items',
        foodItem,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Insert Food Item
  static Future<void> insertFoodItem(String name, double cost) async {
    final db = await database;
    await db.insert(
      'food_items',
      {'name': name, 'cost': cost},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update Food Item
  static Future<void> updateFoodItem(int id, String name, double cost) async {
    final db = await database;
    await db.update(
      'food_items',
      {'name': name, 'cost': cost},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all food items
  static Future<List<Map<String, dynamic>>> getAllFoodItems() async {
    final db = await database;
    return await db.query('food_items');
  }

  // Delete food item
  static Future<void> deleteFoodItem(int id) async {
    final db = await database;
    await db.delete(
      'food_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD for Order Plans

  // Insert Order Plan
  static Future<void> insertOrderPlan(String date, String targetCost, String foodItems) async {
    final db = await database;
    await db.insert(
      'order_plans',
      {
        'date': date,
        'target_cost': targetCost,
        'food_items': foodItems,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Order Plans by Date
  static Future<List<Map<String, dynamic>>> getOrderPlans(String date) async {
    final db = await database;
    var result = await db.query('order_plans', where: 'date = ?', whereArgs: [date]);
    return result;
  }

  // Update Order Plan
  static Future<void> updateOrderPlan(int id, String date, String targetCost, String foodItems) async {
    final db = await database;
    await db.update(
      'order_plans',
      {
        'date': date,
        'target_cost': targetCost,
        'food_items': foodItems,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete Order Plan
  static Future<void> deleteOrderPlan(int id) async {
    final db = await database;
    await db.delete(
      'order_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
