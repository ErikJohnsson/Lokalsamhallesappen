import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/general/congressHelper.dart';

import 'package:lokalsamhallesappen/congress/schedule/Schedule.dart';
import 'package:lokalsamhallesappen/general/colors.dart';

class CongressScheduleService{

  Future<List<Widget>> fullScheduleWidget() async{
    List<Schedule> schedules = new List();

    final congress = await CongressHelper.currentCongressCollection();
    
    DocumentSnapshot scheduleDocument = congress.documents.firstWhere((doc) => doc.documentID == "schedule");

    final days = await scheduleDocument.reference.collection("days").getDocuments();
    days.documents.forEach((day) =>
        schedules.add(new Schedule(day.data["date"], day.data["title"], day.data["activities"])));

    List<Widget> widgets = new List();
    schedules.forEach((s) => widgets.add(widgetForOneDay(s)));
    return widgets;
  }

  Widget widgetForOneDay(Schedule schedule){
    List<Widget> widgets = new List();
    widgets.add(listItemWidget(schedule.title, FontAwesomeIcons.calendar, 20));
    schedule.activities.forEach((activity) => widgets.add(listItemWidget(activity, FontAwesomeIcons.clock, 15)));

    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 50.0,
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(5)
        ),
        child:
        Column(
          children: widgets,
        ),
      ),
    );
  }

  Widget listItemWidget(String text, IconData icon, double fontSize){
    return ListTile(
      leading: Icon(
          icon,
          color: CufColors.mainColor),
      title: Text(
          text,
          style: TextStyle(
              color: CufColors.mainColor,
              fontSize: fontSize
          )
      ),
    );
  }
}