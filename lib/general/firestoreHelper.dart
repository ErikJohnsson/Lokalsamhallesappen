import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper{
  static DocumentSnapshot getDocumentFromCollection(QuerySnapshot collection, String docName){
    return collection.documents.firstWhere((
        doc) => doc.documentID == docName);
  }
}