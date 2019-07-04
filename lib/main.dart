import 'package:flutter/material.dart';
import 'package:lokalsamhallesappen/sakpolitiska/politicsWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar:
          BottomNavigationBar(
            onTap: onTabTapped,
              currentIndex: _selectedPage,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Hem")
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_books),
                    title: Text("Vår politik")
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
      case 0: return Center(
          child: Text("HOME")
      );
      case 1: return PoliticsPageWidget();
    }
  }
}
