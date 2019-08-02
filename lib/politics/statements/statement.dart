import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/general/colors.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class Statement extends StatefulWidget {
  final String title;
  final List<String> statements;
  final NetworkImage backgroundImage;
  int startPage;

  Statement(
    {
      Key key,
      @required
      this.title,
      this.statements,
      this.backgroundImage,
      this.startPage
    }
  ) : super(key: key);

  @override
  _StatementState createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  int _pageSelected = 0;
  ValueNotifier<int> _valueNotifier = new ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    if(widget.startPage != null) {
      _pageSelected = widget.startPage;
      _valueNotifier.value = widget.startPage;
    } 
    return Scaffold(
      body: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(CufColors.mainColor.withOpacity(0.7), BlendMode.srcOver),
              image: widget.backgroundImage
            )
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: _pageSelected == 0 
                          ? Text(
                              widget.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          : Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              widget.statements[_pageSelected-1],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )  
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: CirclePageIndicator(
                    selectedDotColor: Colors.white,
                    dotColor: CufColors.mainColor,
                    itemCount: widget.statements.length+1,
                    currentPageNotifier: _valueNotifier,
                  ),
                )
              ],
            ),
          ),
        ),
        onTapDown: (TapDownDetails details) => _onTapDown(details),
            ),
    );
  }

  _onTapDown(TapDownDetails details) {
    double width = MediaQuery.of(context).size.width;
    if(details.globalPosition.dx < width/2){ // left
      setState(() {
       if(_pageSelected > 0){
         _pageSelected--;
         _valueNotifier.value = _pageSelected;
         widget.startPage = _pageSelected;
       } 
      });
    }
    else { // right
      setState(() {
       if(_pageSelected < widget.statements.length){
         _pageSelected++;
         _valueNotifier.value = _pageSelected;
         widget.startPage = _pageSelected;
       } 
      });
    }
  }

  buildIndexCircles() {
    List<Widget> circles = new List();

    widget.statements.forEach(
      (s) => circles.add(Container(
        height: 5,
        width: 5,
        decoration: BoxDecoration(
          shape: BoxShape.circle
        )
      ))
    );
    return circles;
  }
}