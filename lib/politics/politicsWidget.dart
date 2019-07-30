import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/general/colors.dart';

import 'package:lokalsamhallesappen/politics/sakpolitiska/sakpolitiskaWidget.dart';

import 'ideaprogram/ideaProgramWidget.dart';

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

    return Scaffold(
      body: Column(
          children: <Widget>[
            Expanded(
              child: pageSelected == 0 ? ChaptersPageWidget() : IdeaProgramWidget(),
            ),
            SizedBox(
              height: 52,
              child: buildBottomNavigation()
            ),
          ]
      ),
    );
  }

  Widget buildBottomNavigation(){
    List<Widget> navigationItems = new List();
    navigationItems.add(buildBottomBarNavigationItem(0, "Sakpolitiska"));
    navigationItems.add(buildBottomBarNavigationItem(1, "Idéprogram"));

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: navigationItems.length,
        itemBuilder: (context, index) => navigationItems[index]
    );
  }

  Widget buildBottomBarNavigationItem(int index, String title){
    return GestureDetector(
      child: Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            color: CufColors.mainColor,
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