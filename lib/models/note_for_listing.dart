class NoteForListing {
  int noteId;
  String noteTitle;
  String noteContent;
  
  NoteForListing({this.noteId, this.noteTitle, this.noteContent});

  factory NoteForListing.fromJson(Map<String, dynamic> item) {
    return NoteForListing(
      noteId: item['noteId'],
      noteTitle: item['noteTitle'],
      noteContent: item['noteContent'],      
    );
  }
}