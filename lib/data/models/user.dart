import 'package:flutter/foundation.dart';

class User {
  int id;
  String login;
  String password;

  User({@required this.login, @required this.password, this.id});

  Map<String, dynamic> toMap() {
    return {'id': id, 'login': login, 'password': password};
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    login = map['login'];
    password = map['password'];
  }
}
