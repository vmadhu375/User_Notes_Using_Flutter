class Note {
  
  int noteId;
  String noteTitle;
  String noteContent; 
  
  Note({this.noteId, this.noteTitle, this.noteContent});

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      noteId: item['noteId'],
      noteTitle: item['noteTitle'] ,
      noteContent: item['noteContent'], 
    );
  }
}