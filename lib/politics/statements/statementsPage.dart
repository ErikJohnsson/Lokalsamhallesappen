import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/general/colors.dart';
import 'package:lokalsamhallesappen/politics/statements/statement.dart';
import 'package:lokalsamhallesappen/politics/statements/statement_data.dart';
import 'package:lokalsamhallesappen/politics/statements/statementsService.dart';

class StatementsPage extends StatefulWidget {
  @override
  _StatementsPageState createState() => _StatementsPageState();
}

class _StatementsPageState extends State<StatementsPage> {
  final StatementsSerivce service = new StatementsSerivce();
  bool showLoading = true;
  List<Widget> pages;
  int _pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    if(pages == null ) service.fetchStatements().then((statements) => fetchComplete(statements));

    return Scaffold(
      body: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(CufColors.mainColor.withOpacity(0.7), BlendMode.srcOver),
              image: AssetImage("images/congress_background.jpg")
            )
          ),
          child: showLoading == true
                ? Center(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.9))))
                : PageView(
                    children: pages
                  )
        ),
        //onHorizontalDragEnd: (DragEndDetails details) => _onHorizontalDragEnd(details),
      ),
    );
  }
          
  void fetchComplete(List<StatementData> statements) {
    setState(() {
      showLoading = false;
      pages = new List();
      statements.forEach((s) => pages.add(
        Statement(
          title: s.title,
          statements: s.statements,
          backgroundImage: NetworkImage(s.url),
          startPage: 0,
        )
      ));
    });
  }
}