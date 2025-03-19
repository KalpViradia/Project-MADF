import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/user_class.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender TEXT,
        dob TEXT,
        maritalStatus TEXT,
        country TEXT,
        state TEXT,
        city TEXT,
        religion TEXT,
        caste TEXT,
        subCaste TEXT,
        education TEXT,
        occupation TEXT,
        email TEXT,
        phone TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Insert default users
    await db.insert('users', {
      'name': 'John Doe',
      'gender': 'Male',
      'dob': '15-05-1990',
      'maritalStatus': 'Single',
      'country': 'USA',
      'state': 'California',
      'city': 'Los Angeles',
      'religion': 'Christian',
      'caste': 'Roman Catholic',
      'subCaste': 'Latin Catholic',
      'education': "Bachelor's Degree",
      'occupation': 'Engineer',
      'email': 'john.doe@example.com',
      'phone': '1234567890',
      'isFavorite': 0
    });

    await db.insert('users', {
      'name': 'Aisha Khan',
      'gender': 'Female',
      'dob': '20-07-1995',
      'maritalStatus': 'Married',
      'country': 'India',
      'state': 'Karnataka',
      'city': 'Bangalore',
      'religion': 'Muslim',
      'caste': 'Sunni',
      'subCaste': 'Hanafi',
      'education': "Master's Degree",
      'occupation': 'Doctor',
      'email': 'aisha.khan@example.com',
      'phone': '9876543210',
      'isFavorite': 1
    });

    await db.insert('users', {
      'name': 'David Smith',
      'gender': 'Male',
      'dob': '12-03-1988',
      'maritalStatus': 'Divorced',
      'country': 'UK',
      'state': 'England',
      'city': 'London',
      'religion': 'Christian',
      'caste': 'Protestant',
      'subCaste': 'Baptist',
      'education': "PhD",
      'occupation': 'Teacher',
      'email': 'david.smith@example.com',
      'phone': '1122334455',
      'isFavorite': 0
    });

    await db.insert('users', {
      'name': 'Priya Sharma',
      'gender': 'Female',
      'dob': '10-09-1992',
      'maritalStatus': 'Single',
      'country': 'India',
      'state': 'Maharashtra',
      'city': 'Mumbai',
      'religion': 'Hindu',
      'caste': 'Brahmin',
      'subCaste': 'Iyer',
      'education': "Bachelor's Degree",
      'occupation': 'Business',
      'email': 'priya.sharma@example.com',
      'phone': '9988776655',
      'isFavorite': 1
    });

    await db.insert('users', {
      'name': 'Liam O’Connor',
      'gender': 'Male',
      'dob': '25-11-1993',
      'maritalStatus': 'Widowed',
      'country': 'Canada',
      'state': 'Ontario',
      'city': 'Toronto',
      'religion': 'Jain',
      'caste': 'Shwetambara',
      'subCaste': 'Murtipujaka',
      'education': "Master's Degree",
      'occupation': 'Freelancer',
      'email': 'liam.oconnor@example.com',
      'phone': '7766554433',
      'isFavorite': 0
    });

    await db.insert('users', {
      'name': 'Sophia Williams',
      'gender': 'Female',
      'dob': '18-04-1997',
      'maritalStatus': 'Single',
      'country': 'Australia',
      'state': 'New South Wales',
      'city': 'Sydney',
      'religion': 'Christian',
      'caste': 'Orthodox',
      'subCaste': 'Greek Orthodox',
      'education': "Master's Degree",
      'occupation': 'Engineer',
      'email': 'sophia.williams@example.com',
      'phone': '5566778899',
      'isFavorite': 1
    });

    await db.insert('users', {
      'name': 'Rahul Verma',
      'gender': 'Male',
      'dob': '30-06-1991',
      'maritalStatus': 'Married',
      'country': 'India',
      'state': 'Delhi',
      'city': 'New Delhi',
      'religion': 'Hindu',
      'caste': 'Kshatriya',
      'subCaste': 'Rajput',
      'education': "Bachelor's Degree",
      'occupation': 'Government Employee',
      'email': 'rahul.verma@example.com',
      'phone': '8877665544',
      'isFavorite': 0
    });

    await db.insert('users', {
      'name': 'Maria Gonzalez',
      'gender': 'Female',
      'dob': '22-02-1985',
      'maritalStatus': 'Divorced',
      'country': 'Canada',
      'state': 'Alberta',
      'city': 'Calgary',
      'religion': 'Christian',
      'caste': 'Roman Catholic',
      'subCaste': 'Other',
      'education': "PhD",
      'occupation': 'Teacher',
      'email': 'maria.gonzalez@example.com',
      'phone': '6655443322',
      'isFavorite': 0
    });

    await db.insert('users', {
      'name': 'Mohammed Ali',
      'gender': 'Male',
      'dob': '10-12-1994',
      'maritalStatus': 'Single',
      'country': 'UK',
      'state': 'Wales',
      'city': 'Bangor',
      'religion': 'Muslim',
      'caste': 'Sunni',
      'subCaste': 'Shafi',
      'education': "Master's Degree",
      'occupation': 'Business',
      'email': 'mohammed.ali@example.com',
      'phone': '9988223344',
      'isFavorite': 1
    });

    await db.insert('users', {
      'name': 'Emily Johnson',
      'gender': 'Female',
      'dob': '05-08-1990',
      'maritalStatus': 'Widowed',
      'country': 'USA',
      'state': 'Texas',
      'city': 'Houston',
      'religion': 'Christian',
      'caste': 'Protestant',
      'subCaste': 'Baptist',
      'education': "Bachelor's Degree",
      'occupation': 'Other',
      'email': 'emily.johnson@example.com',
      'phone': '2233445566',
      'isFavorite': 0
    });
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<User>> fetchUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((json) => User.fromMap(json)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
