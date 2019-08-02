import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalsamhallesappen/politics/statements/statement_data.dart';

class StatementsSerivce{
  Future<List<StatementData>> fetchStatements() async{
    final List<StatementData> statements = new List();
    final snapshot = await Firestore.instance
                                    .collection("cufstatements")
                                    .getDocuments();

    snapshot.documents
      .forEach(
        (doc) => {
         statements.add(new StatementData(
           doc.data["title"],
           List.from(doc.data["statements"]),
           doc.data["url"]) 
          )
        });
    return statements;
  }
}