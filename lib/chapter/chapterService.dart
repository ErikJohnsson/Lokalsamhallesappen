import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'chapter.dart';
import 'chapterWidget.dart';
class ChapterService{

  Chapter createChapter(DocumentSnapshot document){
    List<Chapter> subChapters = new List();
    Chapter chapter = new Chapter(document.data["title"], document.data["about"], null);

    document.reference.collection("subchapters").snapshots().listen((snapshot){
      snapshot.documents.forEach((subChapterDoc) =>
          subChapters.add(new Chapter(subChapterDoc.data["title"], subChapterDoc.data["content"], chapter))
      );
    });

    chapter.setSubChapters(subChapters);
    return chapter;
  }

  Future<List<Chapter>> fetchChapters() async{
    List<Chapter> chapters = new List();
    final snapshot = await Firestore.instance.collection("sakpolitiska").getDocuments();
    snapshot.documents.forEach((doc) => chapters.add(createChapter(doc)));

    return chapters;
  }

  Widget buildChapterCards(BuildContext context, List<Chapter> chapters){
    return ListView.builder(
      itemCount: chapters.length,
      itemBuilder: (context, index){
        return buildCard(chapters[index], context);
      }
    );
  }

  Widget buildCard(Chapter chapter, BuildContext context){
    return GestureDetector(child: Container(
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.all(5.0),
      padding: new EdgeInsets.all(5.0),
      height: 66.0,
      decoration: new BoxDecoration(
          color: new Color.fromARGB(255, 172, 202, 87),
          borderRadius: new BorderRadius.all(new Radius.circular(1.0)),
          boxShadow: [new BoxShadow(color: Colors.black54, offset: new Offset(1.0, 1.0), blurRadius: 3.0)]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(Icons.collections_bookmark, color: Colors.white, size: 20),
            ),
            title: AutoSizeText(
              chapter.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
              maxLines: 1,
            ),
            trailing: Icon(Icons.arrow_forward, color: Colors.white, size: 20),

          ),
        ],
      ),
    ),
      onTap:() => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChapterWidget(chapter: chapter,))),
    );
  }
}