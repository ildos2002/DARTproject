import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mynotesapplication/helper/note_provider.dart';
import 'package:mynotesapplication/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:mynotesapplication/screens/note_edit_screen.dart';
import '../widgets/list_item.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {

  FocusNode searchFocusNode = FocusNode();
  String _searchValue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(85.0),
                topRight: Radius.circular(85.0),
              ),
            ),
            height: 130.0,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Text(
                    'ЗАМЕТКИ',
                    style: headerNotesStyle,
                  ),
                Padding(
                  padding: EdgeInsets.only(right: 100),
                  child: Expanded(
                    child: 
                  TextField(
                    focusNode: searchFocusNode,
                    onChanged: (value) => setState(() => _searchValue = value),
                    decoration: InputDecoration(
                      hintText: 'Поиск по названию заметки',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  )    
                ),
                    ],
                  ) 
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<NoteProvider>(
              builder: (context, noteprovider, child) {
                final items = noteprovider.items
                    .where((note) =>
                        note.title.toLowerCase().contains(_searchValue))
                    .toList();
                return items.isEmpty
                    ? child!
                    : ListView.builder(
                        itemCount: items.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return SizedBox(height: 1);
                          } else {
                            final i = index - 1;
                            final item = items[i];
                            return ListItem(
                              item.id,
                              item.title,
                              item.content,
                              item.imagePath,
                              item.date,
                            );
                          }
                        },
                      );
              },
              child: noNotesUI(context),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () { goToNoteEditScreen(context);
         searchFocusNode.unfocus();
         },
        child: Icon(Icons.add),
      ),
    );
  }
  Widget noNotesUI(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 20),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'assets/emoji2.png',
                fit: BoxFit.cover,
                width: 200.0,
                height: 200.0,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: noNotesStyle,
                children: [
                  TextSpan(
                    text: 'Похоже, здесь пока нет ваших заметок.\nНажмите на "',),
                  TextSpan(
                    text: '+',
                    style: boldPlus,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => goToNoteEditScreen(context),
                  ),
                  TextSpan(text: '", чтобы добавить заметку.'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  void goToNoteEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NoteEditScreen.route);
  }
  
}

/* class NoteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<NoteProvider>(context, listen: false).getNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Consumer<NoteProvider>(
                child: noNotesUI(context),
                builder: (context, noteprovider, child) =>
                    noteprovider.items.length <= 0
                        ? child!
                        : ListView.builder(
                            itemCount: noteprovider.items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return header();
                              } else {
                                final i = index - 1;
                                final item = noteprovider.items[i];

                                return ListItem(
                                  item.id,
                                  item.title,
                                  item.content,
                                  item.imagePath,
                                  item.date,
                                );
                              }
                            },
                          ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  goToNoteEditScreen(context);
                },
                child: Icon(Icons.add),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(85.0),
            topRight: Radius.circular(85.0)),
      ),
      height: 70.0,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'ЗАМЕТКИ',
              style: headerNotesStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget noNotesUI(BuildContext context) {
    return ListView(
      children: [
        header(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'assets/emoji2.png',
                fit: BoxFit.cover,
                width: 200.0,
                height: 200.0,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: noNotesStyle, children: [
                TextSpan(
                  text: 'Похоже, здесь пока нет ваших заметок.\nНажмите на "',
                ),
                TextSpan(
                    text: '+',
                    style: boldPlus,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        goToNoteEditScreen(context);
                      }),
                TextSpan(text: '", чтобы добавить заметку.')
              ]),
            ),
          ],
        ),
      ],
    );
  }

  void goToNoteEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NoteEditScreen.route);
  }
} */
