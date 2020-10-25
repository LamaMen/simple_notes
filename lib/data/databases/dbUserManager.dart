import 'package:path/path.dart';
import 'package:simple_notes/data/models/note.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class DBManager {
  static Database _db;

  Future<Database> get db async {
    if (_db == null) _db = await initDB();
    return _db;
  }

  initDB() async {
    var path = join(await getDatabasesPath(), "notes.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, login TEXT, password TEXT);");
    await db.execute("CREATE TABLE notes (userId INTEGER, note TEXT);");
  }

  Future<User> addUser(String login, String password) async {
    var database = await db;
    User user = User(login: login, password: password);
    user.id = await database.insert('users', user.toMap());
    return user;
  }

  Future<User> getUser(String login) async {
    var database = await db;
    List<Map<String, dynamic>> maps = await database.query('users',
        columns: ['id', 'login', 'password'],
        where: 'login = ?',
        whereArgs: [login]);
    List<User> users = [];

    if (maps.isNotEmpty) {
      for (var map in maps) {
        users.add(User.fromMap(map));
      }
    }

    return users.isNotEmpty ? users[0] : null;
  }

  Future<List<Note>> getNotes(int userId) async {
    var database = await db;
    List<Map<String, dynamic>> maps = await database.query('notes',
        columns: ['userId', 'note'],
        where: 'userId = ?',
        whereArgs: [userId]);

    List<Note> notes = [];

    if (maps.isNotEmpty) {
      for (var map in maps) {
        notes.add(Note.fromMap(map));
      }
    }

    return notes;
  }

  Future<int> addNote(Note note) async {
    var database = await db;
    return await database.insert('notes', note.toMap());
  }

  Future<int> deleteNote(Note note) async {
    var database = await db;
    return await database.delete('notes', where: "userId=${note.userId} AND note='${note.note}'");
  }

  close() async {
    var database = await db;
    database.close();
  }
}
