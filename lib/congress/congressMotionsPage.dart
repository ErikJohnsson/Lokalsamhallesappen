import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/congress/motion.dart';
import 'package:url_launcher/url_launcher.dart';

import 'congressMotionService.dart';


class CongressMotionsPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CongressMotionsPageWidgetState();
  }
}

class CongressMotionsPageWidgetState extends State<CongressMotionsPageWidget>{
  Color cufDarkGreen = Color.fromRGBO(001, 106, 058, 1);
  Map<String, List<Motion>> motionsMap;
  List<String> motionChapters;

  @override
  Widget build(BuildContext context) {
    if(motionsMap == null) {
      CongressMotionService service = new CongressMotionService();
      service.fetchChapters().then((motions) => doneFetchingChapters(motions));

      return Scaffold(
        body: Container(
          child: Center(
            child: CircularProgressIndicator(),
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
                colorFilter: new ColorFilter.mode(Color.fromRGBO(001, 106, 058, 0.7), BlendMode.srcOver),
                image: AssetImage("images/motions_background.jpg")
            )
        ),
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: motionChapters.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                child: buildMotionCard(motionChapters[index], getIcon(motionChapters[index])),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => createChapterMotionsPage(motionChapters[index])
                    )
                ),
            );
          },
        ),
      ),
    );
  }


  Widget buildMotionCard(String text, IconData icon) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(5)
        ),
        margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
        child: ListTile(
          leading: Icon(
              icon,
              color: cufDarkGreen),
          title: Text(
            text,
            style: TextStyle(
                color: cufDarkGreen,
                fontSize: 18
            ),
            maxLines: 1,
          ),
        )
    );
  }

  Widget createChapterMotionsPage(String chapter){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Color.fromRGBO(001, 106, 058, 0.7), BlendMode.srcOver),
                image: AssetImage("images/motions_background.jpg")
            )
        ),
        alignment: Alignment.center,
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: motionsMap[chapter].length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  child: buildMotionCard(motionsMap[chapter][index].title, FontAwesomeIcons.newspaper),
                  onTap: () => _launchURL(motionsMap[chapter][index].url)
              );
            },
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  IconData getIcon(String chapterTitle){
    switch(chapterTitle){
      case "Demokrati":
        return FontAwesomeIcons.university;
      case "Människan":
        return FontAwesomeIcons.male;
      case "Jämställdhet":
        return FontAwesomeIcons.balanceScale;
      case "Migration och integration":
        return FontAwesomeIcons.passport;
      case "Miljö":
        return FontAwesomeIcons.tree;
      case "Utbildning":
        return FontAwesomeIcons.graduationCap;
      case "Ekonomi":
        return FontAwesomeIcons.coins;
      case "Internationell politik":
        return FontAwesomeIcons.globeEurope;
      case "Infrastruktur och kommunikationer":
        return FontAwesomeIcons.road;
      default:
        return FontAwesomeIcons.book;
    }
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
