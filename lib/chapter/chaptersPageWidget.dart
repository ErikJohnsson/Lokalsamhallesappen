import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'chapter.dart';
import 'chapterService.dart';
import 'package:html/parser.dart';

import 'chapterWidget.dart';

class ChaptersPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChaptersPageWidgetState();
  }
}

class ChaptersPageWidgetState extends State<ChaptersPageWidget>{
  bool showSearchField = false;
  List<Chapter> chapters;

  void fetchChaptersFinished(List<Chapter> chapters){
    setState(() {
      this.chapters = chapters;
    });
  }

  @override
  Widget build(BuildContext context) {
    ChapterService service = new ChapterService();
    service.fetchChapters().then((result) => fetchChaptersFinished(result));
    if(chapters == null){
      return Scaffold(
          appBar:  AppBar(
            centerTitle: true,
            elevation: 0.1,
            backgroundColor: Color.fromRGBO(001, 106, 058, 1.0),
            title: Text("Sakpolitiska programmet")
          ),
          body: Center(
            child: CircularProgressIndicator(
            ),
          )
      );
    }
    Widget chaptersWidget = service.buildChapterCards(context, chapters);

    ChapterSearch chapterSearch = new ChapterSearch();
    chapterSearch.setChapterList(chapters);

    return Scaffold(
        appBar:  AppBar(
            centerTitle: true,
            elevation: 0.1,
            backgroundColor: Color.fromRGBO(001, 106, 058, 1.0),
            title: Text("Sakpolitiska programmet"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () async {
                    showSearch(context: context, delegate: chapterSearch);
                  })
            ],
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                      child: chaptersWidget
                  )
              ),
            ]
        )
    );
  }

}

class ChapterSearch extends SearchDelegate<Chapter>{
  List<Chapter> chapterList;
  List<Chapter> subChapterList;
  Chapter selectedChapter;
  Chapter subChapterSelected;

  final List<Chapter> recent = new List();

  void setChapterList(List<Chapter> chapterList){
    this.chapterList = chapterList;
    this.subChapterList = getSubChapterList(chapterList);
  }

  List<Chapter> getSubChapterList(List<Chapter> chapterList){
    List<Chapter> subChapters = new List();
    chapterList.forEach((c) => subChapters.addAll(c.subChapters));
    return subChapters;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
      onPressed: (){
          close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ChapterWidget(chapter: selectedChapter, startAtChapter: selectedChapter.subChapters.indexOf(subChapterSelected)+1);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isNotEmpty
        ? subChapterList.where((chapter) => chapter.content.toLowerCase().contains(query.toLowerCase())).toList()
        : recent;
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.book),
          title: Text(suggestionList[index].title),
          subtitle: wordsAroundResult(_parseHtmlString(suggestionList[index].content), query, context),
          onTap: () {
            recent.add(subChapterSelected);
            subChapterSelected = suggestionList[index];
            selectedChapter = suggestionList[index].parent;
            showResults(context);
          },
        ),
         itemCount: suggestionList.length,
    );
  }

  Widget wordsAroundResult(String content, String searchedString, BuildContext context){
    int startIndex = content.indexOf(searchedString) - 250;
    int endIndex = content.indexOf(searchedString) + searchedString.length + 100;

    if(endIndex > content.length){
      endIndex = content.length;
    }
    if(startIndex < 0){
     startIndex = 0;
    }

    return RichText(
      text: TextSpan(
        text: content.substring(startIndex, content.indexOf(searchedString)),
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: content.substring(content.indexOf(searchedString), content.indexOf(searchedString)+searchedString.length),
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: content.substring(content.indexOf(searchedString)+searchedString.length, endIndex)),
        ],
      ),
    );
  }

  String _parseHtmlString(String htmlString) {

    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

}