import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalsamhallesappen/congress/motions/motion.dart';
import 'package:lokalsamhallesappen/general/congressHelper.dart';
import 'package:lokalsamhallesappen/general/firestoreHelper.dart';

class CongressMotionService{
  Future<Map<String, List<Motion>>> fetchChapters() async{
    Map<String, List<Motion>> motionsMap = new Map();

    final congress = await CongressHelper.currentCongressCollection();
    DocumentSnapshot motionsDocument = FireStoreHelper.getDocumentFromCollection(congress, "motions");
    List<String> chaptersInDoc = motionsDocument.data["chapters"].toString().split(",");
    
    for(String chapter in chaptersInDoc){
      final chapterDoc = await motionsDocument.reference.collection(chapter.toLowerCase()).getDocuments();
      List<DocumentSnapshot> motionsData = chapterDoc.documents;
      List<Motion> motions = new List();

      motionsData.forEach((mD) => motions.add(new Motion(mD.data["title"], mD.data["url"])));
      motionsMap.putIfAbsent(chapter, () => motions);
    }

    return motionsMap;
  }
}