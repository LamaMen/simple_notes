import 'package:flutter/material.dart';
import 'package:simple_notes/bloc/notesBloc.dart';
import 'package:simple_notes/data/models/note.dart';
import 'package:simple_notes/data/models/user.dart';

class NotesPage extends StatefulWidget {
  final User user;

  NotesPage({this.user});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _noteController = TextEditingController();
  final _bloc = NotesBloc();
  int userId;
  Future<List<Note>> notes;

  void updateNotes() {
    _bloc.inputEventSink.add(Request(userId, null, Event.getNotes));
  }

  @override
  void initState() {
    userId = widget.user.id;
    updateNotes();
    _bloc.outputStateStream.listen(
      (notes) => setState(() {
        this.notes = notes;
      }),
    );
    super.initState();
  }

  void newNote() {
    setState(() {
      final note = _noteController.text;
      if (note.isNotEmpty) {
        _noteController.clear();
        _bloc.inputEventSink
            .add(Request(userId, Note(userId, note), Event.addNote));
        updateNotes();
      }
      _noteController.clear();
    });
  }

  body() {
    return FutureBuilder(
      future: notes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return list(snapshot.data);
        }
        if (snapshot.data == null || snapshot.data.length == 0) {
          return Center(
              child: Text(
            'Пока заметок нет.',
            style: TextStyle(fontSize: 30),
          ));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ListView list(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          notes[index].note,
          style: TextStyle(fontSize: 20),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _bloc.inputEventSink.add(Request(userId, notes[index], Event.deleteNote));
            updateNotes();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return [
            SliverAppBar(
              excludeHeaderSemantics: false,
              expandedHeight: 200.0,
              pinned: true,
              floating: true,
              forceElevated: boxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "images/background.png",
                  fit: BoxFit.cover,
                ),
                titlePadding: EdgeInsets.only(bottom: 18, left: 25, right: 20),
                title: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: TextField(
                          controller: _noteController,
                          onSubmitted: (_) => newNote(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: "New note...",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: newNote,
                        child: Icon(
                          Icons.add,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: body(),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
