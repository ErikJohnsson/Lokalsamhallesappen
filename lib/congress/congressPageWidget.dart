import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/congress/papers/congressPapersPage.dart';
import 'package:lokalsamhallesappen/congress/schedule/congressScheduleService.dart';
import 'package:lokalsamhallesappen/general/navigationCard.dart';

import 'package:lokalsamhallesappen/congress/motions/congressMotionsPage.dart';
import 'package:lokalsamhallesappen/congress/schedule/fullSchedulePageWidget.dart';
import 'package:lokalsamhallesappen/general/navigationScreen.dart';

class CongressPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CongressPageWidgetState();
  }
}

class CongressPageWidgetState extends State<CongressPageWidget>{
  Widget todaysSchedule;

  @override
  Widget build(BuildContext context) {

    return NavigationScreen(
      backgroundImage: AssetImage("images/congress_background.jpg"),
      children: <Widget>[
        NavigationCard(
            title: "Motioner",
            leadingIcon: FontAwesomeIcons.scroll,
            onTap: () => openNewPage(CongressMotionsPageWidget())
        ),
        NavigationCard(
          title: "Övriga stämmohandlingar",
          leadingIcon: FontAwesomeIcons.book,
          onTap: () => openNewPage(CongressPapersPage()),
        ),
        buildTodaysSchedule(),
        NavigationCard(
          title: "Fullständigt schema",
          leadingIcon: FontAwesomeIcons.calendarDay,
          onTap: () => openNewPage(FullSchedulePageWidget()),
        )
      ],
    );
  }

  void loadedTodaysSchedule(Widget widget){
    if(mounted) {
      setState(() {
        todaysSchedule = widget;
      });
    }
  }

  Widget buildTodaysSchedule(){
    if(todaysSchedule == null){
      CongressScheduleService service = new CongressScheduleService();
      var now = new DateTime.now();

      service.getScheduleForDay(now).then((todaysSchedule) => loadedTodaysSchedule(todaysSchedule));

      return NavigationCard(
        title: "Laddar...",
      );
    }
    return todaysSchedule;
  }

  void openNewPage(Widget newPage) {
    if(newPage!= null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => newPage));
    }
  }

}
