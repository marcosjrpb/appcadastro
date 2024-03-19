import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// criado por Marcos Jr
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
      await (id: 1, nome: 'Marcos Jr', idade: 51);
      await (id: 2, nome: 'Jonas ', idade: 48);
      await (id: 3, nome: 'Maria Luiza', idade: 12);
      await (id: 4, nome: 'João Lucas', idade: 8);
      await (id: 5, nome: 'Antonio', idade: 37);
    } catch (e) {
      print('Erro ao salvar: $e');
    }
  }

  Future<void> _listarUsuarios() async {
    try {
      final db = await DatabaseHelper._openDatabase();
      final List<Map<String, dynamic>> usuarios = await db.query('usuarios');

      usuarios.forEach((usuario) => print('ID: ${usuario['id']},'
          ' Nome: ${usuario['nome']},'
          ' Idade: ${usuario['idade']}'
          ''));
      print("------------------------------------------ \n");
    } catch (e) {
      print('Erro ao listar usuários: $e');
    }
  }

  Future<void> _recuperarusuarioPeloId(int id) async {
    try {
      final db = await DatabaseHelper._openDatabase();
      final List<Map<String, dynamic>> usuarios = await db.query(
        'usuarios',
        columns: ["id", "nome", "idade"],
        where: "id = ?",
        whereArgs: [id],
      );

      usuarios.forEach((usuario) => print("Resultado: "
          'ID: ${usuario['id']},'
          ' Nome: ${usuario['nome']},'
          ' Idade: ${usuario['idade']}'
          ''));

      print("------------------------------------------ \n");
    } catch (e) {
      print('Erro ao recuperar usuário pelo ID: $e');
    }
  }

  Future<void> _atualizarUsuario(int id) async {
    final bd = await DatabaseHelper._openDatabase();
    Map<String, Object> dadosUsuarios =
        await {"nome": "carlos Lins", "idade": 24};
    bd.update("usuarios", dadosUsuarios, where: "id = ?", whereArgs: [id]);

    try {
      print('Usuário Atualizado com sucesso! $id');
      ;
    } catch (e) {
      print('Erro ao excluir usuário pelo ID: $e');
    }
  }

  Future<void> _excluirUsuario(int id) async {
    try {
      print('Usuário excluído com sucesso! $id');
      print("------------------------------------------ \n");
    } catch (e) {
      print('Erro ao excluir usuário pelo ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _recuperarusuarioPeloId(5);
    _excluirUsuario(2);
    _atualizarUsuario(5);
    _listarUsuarios();
    return Container();
  }
}
