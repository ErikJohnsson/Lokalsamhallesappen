import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/congress/schedule/congressScheduleService.dart';
import 'package:lokalsamhallesappen/general/NavigationCard.dart';

import 'package:lokalsamhallesappen/congress/motions/congressMotionsPage.dart';
import 'package:lokalsamhallesappen/congress/schedule/fullSchedulePageWidget.dart';
import 'package:lokalsamhallesappen/general/colors.dart';

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
      return Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(CufColors.mainColor, BlendMode.srcOver),
                image: AssetImage("images/congress_background.jpg")
            )
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              NavigationCard(
                  title: "Motioner",
                  leadingIcon: FontAwesomeIcons.scroll,
                  onTap: () => openNewPage(CongressMotionsPageWidget())
              ),
              NavigationCard(
                title: "Övriga stämmohandlingar (kommer snart)",
                leadingIcon: FontAwesomeIcons.book,
              ),
              buildTodaysSchedule(),
              NavigationCard(
                title: "Fullständigt schema",
                leadingIcon: FontAwesomeIcons.calendarDay,
                onTap: () => openNewPage(FullSchedulePageWidget()),
              )
            ],
          ),
        ),
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

      return Container(
        height: 50,
        width: 20,
        margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Text(
              "Loading...",
              style: TextStyle(fontSize: 20),
          ),
        ),
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
