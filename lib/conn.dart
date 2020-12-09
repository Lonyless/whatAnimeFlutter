import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class Recente {
  int id;
  String nome;

  Recente(this.id, this.nome);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nome': nome,
    };
    return map;
  }

  Recente.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
  }
}

class Conn {
  static Conn _conn;
  static Database _database;

  Conn._createInstance();

  String recenteTable = 'recente';
  String colId = 'id';
  String colNome = 'nome';

  factory Conn() {
    if (_conn == null) {
      _conn = Conn._createInstance();
    }
    return _conn;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'biblioteca.db';
    var userDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return userDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $recenteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNome TEXT)');
  }

  Future<int> insertRecente(Recente recente) async {
    Database db = await this.database;

    var resultado = await db.insert(recenteTable, recente.toMap());

    return resultado;
  }

  Future<Recente> getRecente(int id) async {
    Database db = await this.database;

    List<Map> maps = await db.query(recenteTable,
        columns: [
          colId,
          colNome,
        ],
        where: "$colId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Recente.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteRecente(int id) async {
    var db = await this.database;

    int resultado =
        await db.delete(recenteTable, where: "$colId = ?", whereArgs: [id]);

    return resultado;
  }

  Future deleteAll() async {
    var db = await this.database;

    var resultado = await db.delete(recenteTable);

    return resultado;
  }

  Future<int> getCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $recenteTable');

    int resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  Future<List<Recente>> getRecentes() async {
    Database db = await this.database;

    var resultado = await db.query(recenteTable);

    List<Recente> lista = resultado.isNotEmpty
        ? resultado.map((c) => Recente.fromMap(c)).toList()
        : [];

    return lista;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}