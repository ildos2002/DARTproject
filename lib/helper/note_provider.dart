import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mynotesapplication/helper/database_helper.dart';
import 'package:mynotesapplication/utils/constants.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier{
  
  List _items = [];

  List get items{

    return [..._items];
  }

Note getNote(int? id){
  return _items.firstWhere((note) => note.id == id, orElse: () => Note.empty());
}

  Future deleteNote(int id){
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    return DatabaseHelper.delete(id);
  }

  Future addOrUpdateNote(int? id, String title, String content, String? imagePath, 
  EditMode editMode) async {
    final note = Note(id, title, content, imagePath);

    if(EditMode.ADD == editMode){
      _items.insert(0, note);
    }
    else{
      _items[_items.indexWhere((note) => note.id == id)] = note;
    }

    notifyListeners();

    DatabaseHelper.insert({
        'id' : note.id,
        'title' : note.title,
        'content' : note.content,
        'imagePath' : note.imagePath as String?
    });

  }


  Future getNotes() async {

    final notesList = await DatabaseHelper.getNotesFromBD();

    _items = notesList.map((item) => Note(
      item['id'], item['title'], item['content'], item['imagePath']),
     
     )
     .toList();

     notifyListeners();

  }

}