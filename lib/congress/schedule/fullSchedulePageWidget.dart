import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:lokalsamhallesappen/congress/schedule/congressScheduleService.dart';
import 'package:lokalsamhallesappen/general/colors.dart';

class FullSchedulePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FullSchedulePageWidgetState();
  }
}

class FullSchedulePageWidgetState extends State<FullSchedulePageWidget>{
  Widget allSchedules;
  bool loadedSchedule = false;
  CongressScheduleService service = new CongressScheduleService();

  void setLoadedSchedule(Widget widget){
    setState(() {
      loadedSchedule = true;
      allSchedules = widget;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(allSchedules == null){
      service.fullScheduleWidget().then((widget) => setLoadedSchedule(widget));
      return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(7, 30, 7, 0),
            decoration: BoxDecoration(
              // Box decoration takes a gradient
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(CufColors.mainColor, BlendMode.srcOver),
                    image: AssetImage("images/congress_background.jpg")
                )
            ),
            child: Center(child: CircularProgressIndicator())
        ),
      );
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(7, 30, 7, 0),
        decoration: BoxDecoration(
          // Box decoration takes a gradient
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(CufColors.mainColor, BlendMode.srcOver),
                image: AssetImage("images/congress_background.jpg")
            )
        ),
        child: allSchedules
      ),
    );
  }

}
