import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalsamhallesappen/general/congressHelper.dart';

class CongressPapersService{

  Future<Map<String, String>> fetchPapers() async{
    Map<String, String> papers = new Map();
    
    final congress = await CongressHelper.currentCongressCollection();

    DocumentSnapshot papersDoc = congress.documents.firstWhere((
        doc) => doc.documentID == "papers");

    final papersSnapshot = await papersDoc.reference.collection("pdfs").getDocuments();
    for(int i = 0; i < papersSnapshot.documents.length; i++){
      papers.putIfAbsent(papersSnapshot.documents[i].data["title"], () => papersSnapshot.documents[i].data["url"]);
    }

    return papers;
  }
}