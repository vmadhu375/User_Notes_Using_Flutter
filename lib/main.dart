import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart'; 
import 'package:user_notes/services/notes_services.dart';
import 'package:user_notes/views/login.dart'; 

void setupLocator() {
   GetIt.I.registerLazySingleton(() => NotesService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
       theme: ThemeData( 
        scaffoldBackgroundColor: Colors.white,
      ),
      
      //home:NoteList(), 
       home: LoginPage(),

    );
  }
}

 