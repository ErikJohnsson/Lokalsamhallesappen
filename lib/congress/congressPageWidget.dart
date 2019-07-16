import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/congress/congressScheduleService.dart';

import 'fullSchedulePageWidget.dart';

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
                colorFilter: new ColorFilter.mode(Color.fromRGBO(001, 106, 058, 0.7), BlendMode.srcOver),
                image: AssetImage("images/congress_background.jpg")
            )
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              buildCard("Motioner (kommer snart)",
                  FontAwesomeIcons.scroll,
                  null,
                  null),
              buildCard("Stämmohandlingar (kommer snart)",
                  FontAwesomeIcons.book,
                  null,
                  null),
              buildTodaysSchedule(),
              buildCard("Fullständigt schema",
                        FontAwesomeIcons.clock,
                        FontAwesomeIcons.arrowRight,
                        FullSchedulePageWidget()),
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

  Widget buildCard(String title, IconData icon, IconData endIcon, Widget newPage){
    Color cufDarkGreen = Color.fromRGBO(001, 106, 058, 1);

    return GestureDetector(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(5)
            ),
            margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
            child:ListTile(
              leading: Icon(
                  icon,
                  color: cufDarkGreen),
              trailing:
              Icon(
                endIcon,
                color: cufDarkGreen),
              title: AutoSizeText(
                title,
                style: TextStyle(
                    color: cufDarkGreen,
                    fontSize: 20
                ),
                maxLines: 1,
              ),
            )
        ),
        onTap:() => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => newPage))
    );
  }

}
