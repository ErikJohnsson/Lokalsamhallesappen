import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/congress/motions/motion.dart';
import 'package:lokalsamhallesappen/congress/motions/congressMotionService.dart';
import 'package:lokalsamhallesappen/congress/motions/congressMotionsChapterPage.dart';
import 'package:lokalsamhallesappen/general/navigationCard.dart';
import 'package:lokalsamhallesappen/general/iconService.dart';
import 'package:lokalsamhallesappen/general/navigationScreen.dart';


class CongressMotionsPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CongressMotionsPageWidgetState();
  }
}

class CongressMotionsPageWidgetState extends State<CongressMotionsPageWidget>{

  final CongressMotionService service = new CongressMotionService();
  List<Widget> navigationCards;
  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    if(navigationCards == null) service.fetchChapters().then((motions) => doneFetchingChapters(motions));

    return NavigationScreen(
      backgroundImage: AssetImage("images/motions_background.jpg"),
      children: navigationCards,
      showLoading: showLoading,
    );
  }

  doneFetchingChapters(Map<String, List<Motion>> motions) {
    setState(() {
      navigationCards = new List();
      motions.keys.forEach((chapter) => {
        navigationCards.add(NavigationCard(
          title: chapter,
          leadingIcon: IconService.getIcon(chapter),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CongressMotionsChapterPageWidget(motions: motions[chapter])
              )
          ),
        ))
      });

      showLoading = false;
    });
  }
}
