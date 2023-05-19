import 'package:flutter/material.dart';
import 'package:mynotesapplication/helper/note_provider.dart';
import 'package:mynotesapplication/screens/note_edit_screen.dart';
import 'package:mynotesapplication/screens/note_view_screen.dart';
import 'screens/note_list_screen.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: NoteProvider(),
    child: MaterialApp(
      title: "Заметки",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes:{
        '/':(context)=> NoteListScreen(),
        NoteViewScreen.route:(context)=>NoteViewScreen(),
        NoteEditScreen.route:(context) => NoteEditScreen(),   
      },
    ),
    );
  }
}
