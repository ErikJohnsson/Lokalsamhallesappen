import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/ideaprogram/ideaProgramWidget.dart';

import 'chaptersPageWidget.dart';

class PoliticsPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PoliticsPageWidgetState();
  }
}

class PoliticsPageWidgetState extends State<PoliticsPageWidget>{
  int pageSelected = 0;

  @override
  Widget build(BuildContext context) {

    return Column(
        children: <Widget>[
          Expanded(
            child: Container(
                child: pageSelected == 0 ? ChaptersPageWidget() : IdeaProgramWidget()
            ),
          ),
          SizedBox(
          height: 52,
          child: buildTopNavigation()
          ),
        ]
    );
  }

  Widget buildTopNavigation(){
    List<Widget> navigationItems = new List();
    navigationItems.add(createTopBarNavigationItem(0, "Sakpolitiska"));
    navigationItems.add(createTopBarNavigationItem(1, "Idéprogram"));

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: navigationItems.length,
        itemBuilder: (context, index) => navigationItems[index]
    );
  }

  Widget createTopBarNavigationItem(int index, String title){
    return GestureDetector(
      child: Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            color: Color.fromRGBO(001, 106, 058, 1.0),
          ),
          child: Container(
            decoration: BoxDecoration(
                border: !(pageSelected == index) ? null : Border(
                    bottom: BorderSide(
                        color: Colors.white,
                        width: 6
                    )
                )
            ),
            child: Center(
              child: AutoSizeText(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                ),
              ),
            ),
          )
      ),
      onTap: () {
        setState(() {
          pageSelected = index;
        });
      },
    );
  }
}