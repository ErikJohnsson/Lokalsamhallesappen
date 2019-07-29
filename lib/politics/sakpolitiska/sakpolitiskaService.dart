import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/general/NavigationCard.dart';
import 'package:lokalsamhallesappen/general/iconService.dart';

import '../chapter.dart';
import 'package:lokalsamhallesappen/politics/chapterWidget.dart';
class ChapterService{

  Future<Chapter> createChapter(DocumentSnapshot document) async{
    List<Chapter> subChapters = new List();
    Chapter chapter = new Chapter(document.data["title"], document.data["about"], null);

    final snapshot = await document.reference.collection("subchapters").getDocuments();
    snapshot.documents.forEach((subChapterDoc) =>
        subChapters.add(new Chapter(subChapterDoc.data["title"], subChapterDoc.data["content"], chapter))
    );

    chapter.setSubChapters(subChapters);
    return chapter;
  }

  Future<List<Chapter>> fetchChapters() async{
    List<Chapter> chapters = new List();
    final snapshot = await Firestore.instance.collection("sakpolitiska").getDocuments();
    for(int i = 0; i < snapshot.documents.length; i++){
      Chapter c = await createChapter(snapshot.documents[i]);
      chapters.add(c);
    }

    return chapters;
  }

  List<Widget> buildChapterCards(BuildContext context, List<Chapter> chapters){
    List<Widget> cards = new List();
    chapters.forEach((c) => cards.add((
        NavigationCard(
          title: c.title,
          leadingIcon: IconService.getIcon(c.title),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChapterWidget(chapter: c,))
          )
    ))));

    return cards;
  }
}