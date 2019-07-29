import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokalsamhallesappen/sakpolitiska/politicsWidget.dart';

import 'congress/congressPageWidget.dart';
import 'homescreen/homeScreenWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return MaterialApp(
      title: 'Lokalsamhällesappen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CalibriLight'
      ),
      home: MyHomePage(title: 'Lokalsamhällesappen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;
  Color cufDarkGreen = Color.fromRGBO(001, 106, 058, 1);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar:
          BottomNavigationBar(
            onTap: onTabTapped,
              currentIndex: _selectedPage,
              selectedItemColor: cufDarkGreen,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.home),
                  title: Text("Hem")
                ),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.book),
                    title: Text("Vår politik")
                ),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.gavel),
                    title: Text("Förbundsstämma")
                )
              ]),
            body: getPage()
        )
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  getPage(){
    switch(_selectedPage){
      case 0: return HomePageWidget();
      case 1: return PoliticsPageWidget();
      case 2: return CongressPageWidget();
    }
  }
}
