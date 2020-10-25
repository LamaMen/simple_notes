class Note {
  int userId;
  String note;

  Note(this.userId, this.note);

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'note': note};
  }

  Note.fromMap(Map<String, dynamic> map) {
    userId = map['userId'];
    note = map['note'];
  }
}