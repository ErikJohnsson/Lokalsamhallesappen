import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:lokalsamhallesappen/congress/schedule/Schedule.dart';
import 'package:lokalsamhallesappen/general/colors.dart';

class CongressScheduleService{
  Future<Widget> getScheduleForDay(DateTime date) async {
    if(date.isBefore(new DateTime(2019, 07, 29))){
      return Container(
        margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(5)
        ),
        child: ListTile(
          leading: Icon(
              FontAwesomeIcons.calendar,
              color: CufColors.mainColor),
          title: AutoSizeText(
              "Stämman börjar om " + new DateTime(2019, 07, 29).difference(date).inDays.toString() + " dagar!",
              maxLines: 1,
              style: TextStyle(
                  color: CufColors.mainColor,
                  fontSize: 20
              )
          ),
        ),
      );
    }
    else if(date.isAfter(new DateTime(2019,08,05))){
      return Container(
        margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(5)
        ),
        child: ListTile(
          leading: Icon(
              FontAwesomeIcons.calendar,
              color: CufColors.mainColor),
          title: AutoSizeText(
              "Stämman är slut, ses igen nästa år!",
              maxLines: 1,
              style: TextStyle(
                  color: CufColors.mainColor,
                  fontSize: 20
              )
          ),
        ),
      );
    }
    else {
      String dateString = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
      final congress = await Firestore.instance.collection("congress")
          .getDocuments();
      DocumentSnapshot scheduleDocument = congress.documents.firstWhere((
          doc) => doc.documentID == "schedule");

      final days = await scheduleDocument.reference.collection("days")
          .getDocuments();

      DocumentSnapshot day = days.documents.firstWhere((day) =>
      day.data["date"] == dateString);

      return widgetForOneDay(new Schedule(
          day.data["date"], day.data["title"], day.data["activities"]));
    }
  }

  Future<Widget> fullScheduleWidget() async{
    List<Schedule> schedules = new List();

    final congress = await Firestore.instance.collection("congress").getDocuments();
    DocumentSnapshot scheduleDocument = congress.documents.firstWhere((doc) => doc.documentID == "schedule");

    final days = await scheduleDocument.reference.collection("days").getDocuments();
    days.documents.forEach((day) =>
        schedules.add(new Schedule(day.data["date"], day.data["title"], day.data["activities"])));

      return ListView.builder(
          itemCount: schedules.length,
          itemBuilder: (BuildContext context, int index){
            return widgetForOneDay(schedules[index]);
          }
      );
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