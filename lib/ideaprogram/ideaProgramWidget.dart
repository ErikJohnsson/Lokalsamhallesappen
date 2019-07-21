import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalsamhallesappen/sakpolitiska/chapter.dart';
import 'package:lokalsamhallesappen/sakpolitiska/chapterWidget.dart';

import 'ideaProgramService.dart';

class IdeaProgramWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IdeaProgramWidgetState();
  }
}

class IdeaProgramWidgetState extends State<IdeaProgramWidget>{
  Chapter ideaProgram;

  @override
  Widget build(BuildContext context) {
    if(ideaProgram == null){
      IdeaProgramService service = new IdeaProgramService();
      service.fetchIdeaProgram().then((result) => setIdeaProgram(result));

      return Container(
          child: Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.9))
            ),
          )
      );
    } else {
      return ChapterWidget(chapter: ideaProgram, appBarEnabled: false,);
    }
  }

  void setIdeaProgram(Chapter chapter){
    if(mounted){
      setState(() {
        ideaProgram = chapter;
      });
    }
  }
}