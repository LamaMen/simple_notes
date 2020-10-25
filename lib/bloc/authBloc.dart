import 'dart:async';

import 'package:simple_notes/data/models/user.dart';
import 'package:simple_notes/data/repository.dart';

class AuthBloc {
  final Repository rep = Repository.instance;

  final _inputEventController = StreamController<Request>();
  final _outputStateController = StreamController<Response>();

  StreamSink<Request> get inputEventSink => _inputEventController.sink;

  Stream<Response> get outputStateStream => _outputStateController.stream;

  AuthBloc() {
    _inputEventController.stream.listen(mapEvenToStream);
  }

  void mapEvenToStream(Request request) {
    switch (request.event) {
      case Event.login:
        rep
            .getUserFromLogin(request.login)
            .then((user) => login(user, request.password));
        break;
      case Event.registration:
        rep.getUserFromLogin(request.login).then((user) => registration(user, request));
        break;
    }
  }

  void registration(User user, Request request) {
    if (user != null) {
      _outputStateController.sink.add(Response(null, false));
    } else {
      rep
          .addUser(request.login, request.password)
          .then((user) => _outputStateController.sink.add(Response(user, true)));
    }
  }

  void login(User user, String password) {
    if (user != null && user.password == password) {
      _outputStateController.sink.add(Response(user, true));
    } else {
      _outputStateController.sink.add(Response(null, false));
    }
  }

  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}

enum Event {login, registration}

class Request {
  String login;
  String password;
  Event event;

  Request(this.login, this.password, this.event);
}

class Response {
  final User user;
  final bool isCorrect;

  Response(this.user, this.isCorrect);
}
