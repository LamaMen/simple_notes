import 'dart:async';

import 'package:simple_notes/data/models/note.dart';
import 'package:simple_notes/data/repository.dart';

class NotesBloc {
  final Repository rep = Repository.instance;

  final _inputEventController = StreamController<Request>();
  final _outputStateController = StreamController<Future<List<Note>>>();

  StreamSink<Request> get inputEventSink => _inputEventController.sink;

  Stream<Future<List<Note>>> get outputStateStream => _outputStateController.stream;

  NotesBloc() {
    _inputEventController.stream.listen(mapEvenToStream);
  }

  void mapEvenToStream(Request req) {
    switch (req.event) {
      case Event.getNotes:
        _outputStateController.sink.add(rep.getNotes(req.userId));
        break;
      case Event.addNote:
        rep.addNote(req.note);
        break;
      case Event.deleteNote:
        rep.deleteNote(req.note);
        break;
    }
  }

  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}

enum Event {getNotes, addNote, deleteNote}

class Request {
  int userId;
  Note note;
  Event event;

  Request(this.userId, this.note, this.event);
}

class Response {

}