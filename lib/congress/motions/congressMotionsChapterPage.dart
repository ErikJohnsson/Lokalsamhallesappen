import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/congress/motions/motion.dart';
import 'package:lokalsamhallesappen/general/navigationScreen.dart';
import 'package:lokalsamhallesappen/general/pdfNavigationCard.dart';

class CongressMotionsChapterPageWidget extends StatefulWidget {
  final List<Motion> motions;

  CongressMotionsChapterPageWidget(
      {
        Key key,
        @required this.motions,
      }
      ) : super(key: key
  );

  @override
  State<StatefulWidget> createState() {
    return CongressMotionsChapterPageWidgetState();
  }
}

class CongressMotionsChapterPageWidgetState extends State<CongressMotionsChapterPageWidget>{
  List<Motion> downloading = new List();

  @override
  Widget build(BuildContext context) {
    return NavigationScreen(
      backgroundImage: AssetImage("images/motions_background.jpg"),
      children: buildNavigationCards(),
    );
  }

  List<Widget> buildNavigationCards(){
    List<Widget> widgets = new List();
    widget.motions.forEach((m) => widgets.add(PdfNavigationCard(
      title: m.title,
      url: m.url,
      leadingIcon: FontAwesomeIcons.fileAlt,
    )));
    return widgets;
  }
}
