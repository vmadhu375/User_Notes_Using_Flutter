 
import 'package:flutter/material.dart';
import 'package:user_notes/models/api_response.dart';
import 'package:user_notes/models/note_for_listing.dart';
import 'package:get_it/get_it.dart';
import 'package:user_notes/services/notes_services.dart';
import 'package:user_notes/views/note_delete.dart';
import 'package:user_notes/views/note_modify.dart'; 
import 'login.dart';
import 'note_modify.dart';

  

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();

  APIResponse<List<NoteForListing>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('List of notes'),
         actions: <Widget> [
        IconButton(
          tooltip: "Log-Out",
          icon: Icon(Icons.people),          
           onPressed: ()  {
           Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
               
        },
       
        )
      ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NoteModify()))
                .then((_) {
                  _fetchNotes();
                });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_apiResponse.error) {
              return Center(child: Text(_apiResponse.errorMessage));
            }

            return ListView.separated(
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.green),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].noteId),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => NoteDelete());

                    if (result) {
                      final deleteResult = await service.deleteNote(_apiResponse.data[index].noteId);

                      var message;
                      if (deleteResult != null && deleteResult.data == true) {
                        message = 'The note was deleted successfully';
                      } else {
                        message = deleteResult?.errorMessage ?? 'An error occured';
                      }

                    showDialog(
                      context: context, builder: (_) => AlertDialog(
                        title: Text('Done'),
                        content: Text(message),
                        actions: <Widget>[
                          FlatButton(child: Text('Ok'), onPressed: () {
                            Navigator.of(context).pop();
                          })
                        ],
                      ));

                      return deleteResult?.data ?? false;
                    }
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      _apiResponse.data[index].noteTitle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text( 
                       _apiResponse.data[index].noteContent ?? _apiResponse.data[index].noteContent,
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                       ),
                     onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NoteModify(
                              noteId : _apiResponse.data[index].noteId))).then((data) {
                                _fetchNotes();
                              });
                    },
                  ),
                );
              },
              itemCount: _apiResponse.data.length,
            );
          },
        ));
  }
}