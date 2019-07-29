import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/congress/motions/motion.dart';
import 'package:lokalsamhallesappen/congress/motions/congressMotionService.dart';
import 'package:lokalsamhallesappen/congress/motions/congressMotionsChapterPage.dart';
import 'package:lokalsamhallesappen/general/NavigationCard.dart';
import 'package:lokalsamhallesappen/general/colors.dart';
import 'package:lokalsamhallesappen/general/iconService.dart';


class CongressMotionsPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CongressMotionsPageWidgetState();
  }
}

class CongressMotionsPageWidgetState extends State<CongressMotionsPageWidget>{
  Map<String, List<Motion>> motionsMap;
  List<String> motionChapters;

  @override
  Widget build(BuildContext context) {
    if(motionsMap == null) {
      CongressMotionService service = new CongressMotionService();
      service.fetchChapters().then((motions) => doneFetchingChapters(motions));

      return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              // Box decoration takes a gradient
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(CufColors.mainColor.withOpacity(0.7), BlendMode.srcOver),
                    image: AssetImage("images/motions_background.jpg")
                )
            ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.9)),
            ),
          )
        )
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(CufColors.mainColor.withOpacity(0.7), BlendMode.srcOver),
                image: AssetImage("images/motions_background.jpg")
            )
        ),
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: motionChapters.length,
          itemBuilder: (BuildContext context, int index) {
            return NavigationCard(
                title: motionChapters[index],
                leadingIcon: IconService.getIcon(motionChapters[index]),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CongressMotionsChapterPageWidget(motions: motionsMap[motionChapters[index]])
                    )
                ),
            );
          },
        ),
      ),
    );
  }

  doneFetchingChapters(Map<String, List<Motion>> motions) {
    setState(() {
      motionChapters = new List();
      for(String chapter in motions.keys){
        motionChapters.add(chapter);
      }
      motionsMap = motions;
    });
  }
}
