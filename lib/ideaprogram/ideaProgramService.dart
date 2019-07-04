import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalsamhallesappen/sakpolitiska/chapter.dart';

class IdeaProgramService{

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

  Future<Chapter> fetchIdeaProgram() async{
    Chapter chapter;
    final snapshot = await Firestore.instance.collection("ideprogram").getDocuments();
    chapter = createChapter(snapshot.documents[0]);

    return chapter;
  }
}