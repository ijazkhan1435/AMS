import 'dart:async';
import 'dart:io';
import 'package:flutter_application_1/src/models/task_model.dart';
import 'package:flutter_application_1/src/utils/uidata/staticData.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper extends GetxController {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  String androidDbPath = '';

  /// ✅ **Fixed createFolder Method**
  Future<void> createFolder() async {
    if (androidDbPath.isNotEmpty) return; // Already set, no need to recreate

    var path = await getExternalStorageDirectory();
    if (path == null) {
      print("Error: Storage directory not found.");
      return;
    }

    androidDbPath = '${path.path}/ET-AMS';

    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await [
        Permission.manageExternalStorage,
        Permission.storage,
        Permission.accessMediaLocation
      ].request();
    }

    final dir = Directory(androidDbPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      print('✔ Folder Created: $androidDbPath');
    }
  }

  Future<Database> get databasee async {
    if (Platform.isAndroid) {
      await createFolder();
    }

    if (database == null) {
      database = await initializeDatabase();
      print('✔ Database Initialized');
    }
    return database!;
  }

  /// ✅ **Fixed initializeDatabase Method**
  Future<Database> initializeDatabase() async {
    await createFolder(); // Ensure folder is created

    final dbPath = androidDbPath; // ✅ No repetition issue now
    const dbName = 'rfid.db';

    return await openDatabase(
      '$dbPath/$dbName',
      version: 1,
      onCreate: (db, version) async {
        print('Creating Database');
        await db.execute(
            'CREATE TABLE assets (id INTEGER PRIMARY KEY AUTOINCREMENT,'
                ' assetTagID TEXT, assetID TEXT, assetsStatus TEXT, purchasedDate TEXT,'
                ' categoryDescription TEXT, assetDescription TEXT, cost TEXT, createdDate TEXT,'
                ' siteID TEXT, siteDescription TEXT, locationID TEXT, locationDescription TEXT,'
                ' image TEXT, isActive TEXT, depreciation TEXT, depreciationMethod TEXT,'
                ' isDepreciation TEXT, employeeID TEXT, categoryID TEXT,'
                ' assetIsActive TEXT, employeeName TEXT)');

        await db.execute(
            'CREATE TABLE location (id INTEGER PRIMARY KEY AUTOINCREMENT, locationID INTEGER, locationDescription TEXT, siteID INTEGER, siteDescription TEXT)');
        await db.execute(
            'CREATE TABLE category (id INTEGER PRIMARY KEY AUTOINCREMENT, categoryID INTEGER, categoryDescription TEXT)');
        await db.execute(
            'CREATE TABLE site (id INTEGER PRIMARY KEY AUTOINCREMENT, siteID INTEGER, siteDescription TEXT)');
        await db.execute(
            'CREATE TABLE selectDetails (id INTEGER PRIMARY KEY AUTOINCREMENT, locationID INTEGER, locationDescription TEXT, siteID INTEGER, siteDescription TEXT)');
      },
    );
  }

  Future<void> insertAssets(Map<String, dynamic> assetData) async {
    final db = await databasee;
    await db.insert('assets', assetData);
  }

  Future<void> insertLocation(Map<String, dynamic> locationData) async {
    final db = await databasee;
    await db.insert('location', locationData);
  }

  Future<void> insertCategory(Map<String, dynamic> categoryData) async {
    final db = await databasee;
    await db.insert('category', categoryData);
  }

  Future<void> insertSite(Map<String, dynamic> siteData) async {
    final db = await databasee;
    await db.insert('site', siteData);
  }
  Future<void> insertSelectDetails(Map<String, dynamic> selectDetailsData) async {
    final db = await databasee;
    await db.insert('selectDetails', selectDetailsData);
  }

  Future<int> insertTask(Task task) async {
    final db = await databasee;
    return await db.insert('assets', task.toMap());
  }

  getTasks(String table) async {
    final db = await databasee;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return maps;
  }

  Future<void> updateTask(Task task) async {
    final db = await databasee;
    await db.update(
      'assets',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.assetTagID],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await databasee;
    await db.delete(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTable(String tableName) async {
    final db = await databasee;
    await db.execute("DROP TABLE IF EXISTS $tableName");
  }

  Future<void> createTable(String tableName) async {
    final db = await databasee;
    if (tableName == 'location') {
      await db.execute(
          'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, locationID INTEGER, locationDescription TEXT, siteID INTEGER, siteDescription TEXT)');
    } else if (tableName == 'category') {
      await db.execute(
          'CREATE TABLE category (id INTEGER PRIMARY KEY AUTOINCREMENT, categoryID INTEGER, categoryDescription TEXT)');
    } else if (tableName == 'site') {
      await db.execute(
          'CREATE TABLE site (id INTEGER PRIMARY KEY AUTOINCREMENT, siteID INTEGER, siteDescription TEXT)');
    } else if (tableName == 'selectDetails') {
      await db.execute(
          'CREATE TABLE selectDetails (id INTEGER PRIMARY KEY AUTOINCREMENT, locationID INTEGER, locationDescription TEXT, siteID INTEGER, siteDescription TEXT)');
    } else {
      await db.execute(
          'CREATE TABLE $tableName  (id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' assetTagID TEXT, assetID TEXT, assetsStatus TEXT, purchasedDate TEXT,'
              ' categoryDescription TEXT, assetDescription TEXT, cost TEXT, createdDate TEXT,'
              ' siteID TEXT, isActive TEXT, siteDescription TEXT, locationID TEXT,'
              ' locationDescription TEXT, image TEXT, depreciation TEXT,'
              ' depreciationMethod TEXT, isDepreciation TEXT, employeeID TEXT,'
              ' categoryID TEXT, assetIsActive TEXT, employeeName TEXT)');
    }
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = androidDbPath;
    const dbName = 'rfid.db';
    await deleteDatabase('$dbPath/$dbName');
    print('✔ Database Deleted');
  }

  Future<void> updateAssetStatusIfFound(List filterData, String status) async {
    for (var asset in filterData) {
      String assetTagID = asset['assetTagID'];
      final List<Map<String, dynamic>> existingAsset = await database!.query(
        'assets',
        where: 'assetTagID = ?',
        whereArgs: [assetTagID],
      );
      if (existingAsset.isNotEmpty) {
        await database?.update(
          'assets',
          {'assetsStatus': '$status'},
          where: 'assetTagID = ?',
          whereArgs: [assetTagID],
        );
      }
    }
  }

  Future<void> updateAssetStatus(String assetTagID, String newStatus) async {
    await database!.update(
      'assets',
      {'assetsStatus': newStatus},
      where: 'assetTagID = ?',
      whereArgs: [assetTagID],
    );
  }
}


