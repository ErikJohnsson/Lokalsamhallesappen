import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalsamhallesappen/congress/motion.dart';

class CongressMotionService{
  Future<Map<String, List<Motion>>> fetchChapters() async{
    Map<String, List<Motion>> motionsMap = new Map();

    final congress = await Firestore.instance.collection("congress")
        .getDocuments();
    DocumentSnapshot motionsDocument = congress.documents.firstWhere((
        doc) => doc.documentID == "motions");

    List<String> chaptersInDoc = motionsDocument.data["chapters"].toString().split(",");

    for(String chapter in chaptersInDoc){
      final chapterDoc = await motionsDocument.reference.collection(chapter.toLowerCase()).getDocuments();
      List<DocumentSnapshot> motionsData = chapterDoc.documents;
      List<Motion> motions = new List();

      for(DocumentSnapshot motionData in motionsData){
        motions.add(new Motion(motionData.data["title"], motionData.data["url"]));
      }

      motionsMap.putIfAbsent(chapter, () => motions);
    }

    return motionsMap;
  }
}