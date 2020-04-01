import 'package:cloud_firestore/cloud_firestore.dart';

class CongressHelper {
  
  static Future<QuerySnapshot> currentCongressCollection() async{
    final settings = await Firestore.instance.collection("settings").getDocuments();
    String congressYear = settings.documents.firstWhere((doc) => doc.documentID == "congress_settings").data["currentCongress"];
    return Firestore.instance.collection(congressYear).getDocuments();
  }
}