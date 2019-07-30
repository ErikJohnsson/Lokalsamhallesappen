import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/general/colors.dart';
import 'package:lokalsamhallesappen/general/navigationScreen.dart';

import '../chapter.dart';
import 'package:lokalsamhallesappen/politics/sakpolitiska/sakpolitiskaService.dart';
import 'package:html/parser.dart';

import 'package:lokalsamhallesappen/politics/chapterWidget.dart';

class ChaptersPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChaptersPageWidgetState();
  }
}

class ChaptersPageWidgetState extends State<ChaptersPageWidget>{
  final ChapterService service = new ChapterService();
  final ChapterSearch chapterSearch = new ChapterSearch();
  List<Widget> navigationCards = new List();
  bool showLoading = true;
  bool showSearchField = false;
  List<Chapter> chapters;

  void fetchChaptersFinished(List<Chapter> chapters){
    if(mounted) {
      setState(() {
        this.chapters = chapters;
        chapterSearch.setChapterList(chapters);
        showLoading = false;
        navigationCards.add(GestureDetector(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white.withOpacity(0.9),
                ),
                margin: EdgeInsets.fromLTRB(25, 0, 25, 8),
                child:ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                        hintText: "Sök...",
                        border: InputBorder.none
                    ),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                    onTap: () => showSearch(context: context, delegate: chapterSearch),
                  ),
                  leading: Icon(FontAwesomeIcons.search, color: CufColors.mainColor),
                )
            ),
            onTap:() => showSearch(context: context, delegate: chapterSearch)
        ));
        navigationCards.addAll(service.buildChapterCards(context, chapters));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(chapters == null)service.fetchChapters().then((result) => fetchChaptersFinished(result));
    
    return NavigationScreen(
      backgroundImage: AssetImage("images/sakpolitiska_background.jpg"),
      children: navigationCards,
      showLoading: showLoading,
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
    if(selectedChapter != null && subChapterSelected != null) {
      return ChapterWidget(chapter: selectedChapter,
          startAtChapter: selectedChapter.subChapters.indexOf(
              subChapterSelected) + 1);
    }else{
      return Center(
      child: Text(
          "Hittade ingenting.",
          style: TextStyle(fontSize: 18),
      )
    );
    }
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