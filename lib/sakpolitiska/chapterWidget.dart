import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'chapter.dart';

class ChapterWidget extends StatefulWidget {
  final Chapter chapter;
  final int startAtChapter;
  final bool appBarEnabled;

  ChapterWidget(
      {
        Key key,
        @required this.chapter,
        this.startAtChapter = 0,
        this.appBarEnabled = true
      }
      ) : super(key: key
  );

  @override
  State<StatefulWidget> createState() {
    return new ChapterWidgetState();
  }


}

class ChapterWidgetState extends State<ChapterWidget>{
  PageController _controller;
  ListView topBarNavigation;
  ScrollController _scrollController;
  final Map<int, bool> pageSelected = new Map();

  @override
  Widget build(BuildContext context) {
    Widget chapterPage = buildChapterPage();
    return chapterPage;
  }

  void topNavigationBarClicked(int index, BuildContext context){
    _controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);

    double navigationItemSize = MediaQuery.of(context).size.width / 3;
    _scrollController.jumpTo((index-1)*navigationItemSize);

    setState(() {
      for(int i = 0; i < pageSelected.keys.length; i++){
        pageSelected[i] = false;
      }

      pageSelected[index] = true;
    });
  }

  void pagedScrolled(int index){
    double navigationItemSize = MediaQuery.of(context).size.width / 3;
    _scrollController.animateTo((index-1)*navigationItemSize, duration: Duration(milliseconds: 250), curve: Curves.ease);

    setState(() {
      for(int i = 0; i < pageSelected.keys.length; i++){
        pageSelected[i] = false;
      }

      pageSelected[index] = true;
    });
  }

  Widget buildTopNavigation(Chapter chapter){
    List<Widget> navigationItems = new List();
    for(int index = 0; index < widget.chapter.subChapters.length+1; index++){
      pageSelected.putIfAbsent(index, () => false);
    }
    if(topBarNavigation == null) {
      pageSelected[widget.startAtChapter] = true;
    }

    navigationItems.add(GestureDetector(
      child: Container(
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            color: Color.fromRGBO(001, 106, 058, 1.0),
          ),
          child: Container(
                decoration: BoxDecoration(
                    border: !pageSelected[0] ? null : Border(
                        bottom: BorderSide(
                            color: Colors.white,
                            width: 6
                        )
                    )
                ),
                child: Center(
                  child: Text(
                    widget.chapter.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                    ),
                  ),
                ),

          )
      ),
      onTap: () => topNavigationBarClicked(0, context),
    ));

    for(int index = 1; index < chapter.subChapters.length+1; index++){
      navigationItems.add(createTopBarNavigationItem(index));
    }
    _scrollController = new ScrollController();

    topBarNavigation = ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemCount: navigationItems.length,
      itemBuilder: (context, index) => navigationItems[index]
    );
    return topBarNavigation;
  }

  Widget createTopBarNavigationItem(int index){
    return GestureDetector(
      child: Container(
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            color: Color.fromRGBO(001, 106, 058, 1.0),
          ),
          child: Container(
                    decoration: BoxDecoration(
                      border: !pageSelected[index] ? null : Border(
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 6
                        )
                      )
                    ),
                    child: Center(
                      child: AutoSizeText(
                      widget.chapter.subChapters[index-1].title,
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
      onTap: () => topNavigationBarClicked(index, context),
    );
  }

  Widget buildPageView(Chapter chapter){
    List<Widget> pages = new List();
    pages.add(Container(
        child:  buildSubChapterPage(chapter)
    ));

    for(int index = 0; index < chapter.subChapters.length; index++) {
      pages.add(Container(
          child:  buildSubChapterPage(chapter.subChapters[index])
          )
      );
    }
    _controller = PageController(initialPage: widget.startAtChapter, keepPage: false);

    return PageView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: pages.length,
        itemBuilder: (context, index) => pages[index],
        controller: _controller,
        onPageChanged: (index) => pagedScrolled(index));
  }

  Widget buildChapterPage(){
    return Scaffold(
        appBar: widget.appBarEnabled ? AppBar(
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(001, 106, 058, 1.0),
          title: Text(widget.chapter.title)
        ) : null,
        body: Column(
            children: <Widget>[
              SizedBox(
                  height: 52,
                  child: buildTopNavigation(widget.chapter)
              ),
              Expanded(child: buildPageView(widget.chapter))
            ]
        )
    );
  }


  Widget buildSubChapterPage(Chapter subChapter){
    return Scrollbar(child: SingleChildScrollView(
                padding: new EdgeInsets.all(5.0),
                scrollDirection: Axis.vertical,
                child: Html( data: subChapter.content)
        ));
  }


}

