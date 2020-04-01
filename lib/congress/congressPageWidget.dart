import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/congress/papers/congressPapersPage.dart';
import 'package:lokalsamhallesappen/congress/schedule/congressScheduleService.dart';
import 'package:lokalsamhallesappen/general/congressHelper.dart';
import 'package:lokalsamhallesappen/general/firestoreHelper.dart';
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
  List<Widget> congressCards;

  @override
  Widget build(BuildContext context) {
    return NavigationScreen(
        backgroundImage: AssetImage("images/congress_background.jpg"),
        children: getCongressCards()
      );
  }

  List<Widget> getCongressCards(){
    if(congressCards == null){
      fetchCongressCards().then((cards) => {
          if(mounted) {
            setState(() {
              congressCards = cards;
            })
          }
        });

        return [NavigationCard(
            title: "Laddar...",
        )];
    }
    return congressCards;
  }

  Future<List<Widget>> fetchCongressCards() async{
    final congress = await CongressHelper.currentCongressCollection();
    bool activated = FireStoreHelper.getDocumentFromCollection(congress, "settings").data["activate"];
    if(activated){
      return [
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
          NavigationCard(
            title: "Schema",
            leadingIcon: FontAwesomeIcons.calendarDay,
            onTap: () => openNewPage(FullSchedulePageWidget()),
          )
      ];
    }
    else{
      return [NavigationCard(
        title: "Into redo ännu...",
        leadingIcon: FontAwesomeIcons.clock,
      )];
    }
  }

  void loadedTodaysSchedule(Widget widget){
    if(mounted) {
      setState(() {
        todaysSchedule = widget;
      });
    }
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
