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

  List<Widget> buildChapterCards(BuildContext context, List<Chapter> chapters){
    List<Widget> cards = new List();
    chapters.forEach((c) => cards.add((buildCard(c, context))));

    return cards;
  }

  Widget buildCard(Chapter chapter, BuildContext context){
      return GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(172, 202, 87, 0.9),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
                    child:ListTile(
                      leading: Icon(Icons.book, color: Colors.white),
                      title: AutoSizeText(
                        chapter.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        ),
                        maxLines: 1,
                      ),
                      )
                ),
            onTap:() => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChapterWidget(chapter: chapter,)))
      );
  }
}