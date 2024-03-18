import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(MaterialApp(home: Home()));

class User {
  final int id;
  final String nome;
  final int idade;

  User({required this.id, required this.nome, required this.idade});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
    };
  }
}

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'banco.db');

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, idade INTEGER)',
        );
      },
    );
  }

  static Future<int> insertUser(User user) async {
    final db = await _openDatabase();
    return await db.insert(
      'usuarios',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _salvar();
  }

  Future<void> _salvar() async {
    try {
      final user = User(id: 1, nome: 'Marcos Jr', idade: 58);
      final id = await DatabaseHelper.insertUser(user);
      print('Salvo: $id');
    } catch (e) {
      print('Erro ao salvar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
