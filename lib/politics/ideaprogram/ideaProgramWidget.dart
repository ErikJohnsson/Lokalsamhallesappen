import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/politics/chapter.dart';
import 'package:lokalsamhallesappen/politics/chapterWidget.dart';

import 'ideaProgramService.dart';

class IdeaProgramWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IdeaProgramWidgetState();
  }
}

class IdeaProgramWidgetState extends State<IdeaProgramWidget>{
  Chapter ideaProgram;
  bool fetched = false;

  @override
  Widget build(BuildContext context) {
    if(!fetched){
      fetched = true;
      IdeaProgramService service = new IdeaProgramService();
      service.fetchIdeaProgram().then((result) => setIdeaProgram(result));
    }

    if(ideaProgram == null) {
      return Container(
          child: Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.9))
            ),
          )
      );
    }

    return ChapterWidget(chapter: ideaProgram, appBarEnabled: false,);
  }

  void setIdeaProgram(Chapter chapter){
    if(mounted){
      setState(() {
        ideaProgram = chapter;
      });
    }
  }
}