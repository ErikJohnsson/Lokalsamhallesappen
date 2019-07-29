import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalsamhallesappen/politics/chapter.dart';

class IdeaProgramService{

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

  Future<Chapter> fetchIdeaProgram() async{
    Chapter chapter;
    final snapshot = await Firestore.instance.collection("ideprogram").getDocuments();
    chapter = await createChapter(snapshot.documents[0]);
    return chapter;
  }
}