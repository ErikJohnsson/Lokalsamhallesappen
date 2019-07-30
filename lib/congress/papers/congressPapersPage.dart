import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/general/navigationScreen.dart';
import 'package:lokalsamhallesappen/general/pdfNavigationCard.dart';

import 'congressPapersService.dart';

class CongressPapersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CongressPapersPageState();
  }
}

class CongressPapersPageState extends State<CongressPapersPage>{
  final CongressPapersService service = new CongressPapersService();
  List<Widget> navigationCards;
  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    if(navigationCards == null) service.fetchPapers().then((p) => downloadComplete(p));

    return NavigationScreen(
      backgroundImage: AssetImage("images/motions_background.jpg"),
      children: navigationCards,
      showLoading: showLoading,
    );
  }

  void downloadComplete(Map<String, String> papers){
    setState(() {
      navigationCards = new List();
      papers.keys.forEach(
              (title) => navigationCards.add(PdfNavigationCard(
                title: title,
                url: papers[title],
                leadingIcon: FontAwesomeIcons.file,
              )));
      showLoading = false;
    });
  }
}
