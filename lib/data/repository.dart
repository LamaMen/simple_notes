import 'databases/dbUserManager.dart';
import 'models/note.dart';
import 'models/user.dart';

class Repository {
  DBManager _db = DBManager();

  Repository._privateConstructor();

  static final Repository _instance = Repository._privateConstructor();

  static Repository get instance => _instance;

  Future<List<Note>> getNotes(int userId) async {
    return await _db.getNotes(userId);
  }

  void addNote(Note note) async {
    await _db.addNote(note);
  }

  void deleteNote(Note note) async {
    await _db.deleteNote(note);
  }

  Future<User> getUserFromLogin(String login) async {
    return await _db.getUser(login);
  }

  Future<User> addUser(String login, String password) {
    return _db.addUser(login, password);
  }

  dispose() {
    _db.close();
  }
}
