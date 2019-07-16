import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    Color cufDarkGreen = Color.fromRGBO(001, 106, 058, 1);

      return GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
                    child:ListTile(
                      leading: Icon(
                          getIcon(chapter.title),
                          color: cufDarkGreen),
                      title: AutoSizeText(
                        chapter.title,
                        style: TextStyle(
                            color: cufDarkGreen,
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

  IconData getIcon(String chapterTitle){
    switch(chapterTitle){
      case "Demokrati":
        return FontAwesomeIcons.university;
      case "Människan":
        return FontAwesomeIcons.male;
      case "Jämställdhet":
        return FontAwesomeIcons.balanceScale;
      case "Migration och integration":
        return FontAwesomeIcons.passport;
      case "Miljö":
        return FontAwesomeIcons.tree;
      case "Utbildning":
        return FontAwesomeIcons.graduationCap;
      case "Ekonomi":
        return FontAwesomeIcons.coins;
      case "Internationell politik":
        return FontAwesomeIcons.globeEurope;
      case "Infrastruktur och kommunikationer":
        return FontAwesomeIcons.road;
      default:
        return FontAwesomeIcons.book;
    }
  }
}