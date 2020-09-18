import 'package:flutter/material.dart';
import 'package:user_notes/models/note.dart';
import 'package:get_it/get_it.dart';
import 'package:user_notes/models/note_insert.dart';
import 'package:user_notes/services/notes_services.dart';
import 'package:user_notes/views/login.dart';
import 'package:user_notes/views/note_list.dart';

class NoteModify extends StatefulWidget {
 
  final int noteId;
  NoteModify({this.noteId});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteId != null;

  NotesService get notesService => GetIt.I<NotesService>();

  String errorMessage;
  Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteContentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      notesService.getNote(widget.noteId)
        .then((response) {
          setState(() {
            _isLoading = false;
          });

          if (response.error) {
            errorMessage = response.errorMessage ?? 'An error occurred';
          }
          note = response.data;
          _titleController.text = note.noteTitle;
          _noteContentController.text = note.noteContent;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note'),
      actions: <Widget> [
        IconButton(
          tooltip: "Log-Out",
          icon: Icon(Icons.people),           
           onPressed: ()  {
           Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
               
        },
        ), 
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Note title'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: _noteContentController,
              decoration: InputDecoration(
                hintText: 'Note Content'
              ),
            ),

            Container(height: 16),

            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  if (isEditing) {
                    setState(() {
                      _isLoading = true;
                    });
                    final note = NoteManipulation(
                      noteTitle: _titleController.text,
                      noteContent: _noteContentController.text
                    );
                    final result = await notesService.updateNote(widget.noteId, note);
                    
                    setState(() {
                      _isLoading = false;
                    });

                    final title = 'Done';
                    final text = result.error ? (result.errorMessage ?? 'An error occurred') : 'Your note was updated';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    )
                    .then((data) {
                      if (result.data) {
                        Navigator.of(context).pop();
                      }
                    });

                  } else {
                    
                    setState(() {
                      _isLoading = true;
                    });
                    final note = NoteManipulation(
                      noteTitle: _titleController.text,
                      noteContent: _noteContentController.text
                    );
                     if(_titleController.text == "" || _noteContentController.text == ""){  
                        showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Info"),
                        content: Text("Please Enter Title the Note Content"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    ) .then((data) {
                         Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NoteModify()));
                    });
                    
                 
                  }else{

                    final result = await notesService.createNote(note);
                    
                    setState(() {
                      _isLoading = false;
                    });

                     final title = 'Done';
                    final text = result.error ? (result.errorMessage ?? 'Error Occured') : 'Your note was created';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    )
                    .then((data) {
                         Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => NoteList()));
                    });
                  }
                    

                   
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}