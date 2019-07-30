import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:lokalsamhallesappen/congress/schedule/congressScheduleService.dart';
import 'package:lokalsamhallesappen/general/navigationScreen.dart';

class FullSchedulePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FullSchedulePageWidgetState();
  }
}

class FullSchedulePageWidgetState extends State<FullSchedulePageWidget>{
  List<Widget> allSchedules;
  bool showLoading = true;
  CongressScheduleService service = new CongressScheduleService();

  void setLoadedSchedule(List<Widget> widget){
    setState(() {
      showLoading = false;
      allSchedules = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(allSchedules == null) service.fullScheduleWidget().then((widget) => setLoadedSchedule(widget));

    return NavigationScreen(
      backgroundImage: AssetImage("images/congress_background.jpg"),
      children: allSchedules,
      showLoading: showLoading,
    );
  }

}