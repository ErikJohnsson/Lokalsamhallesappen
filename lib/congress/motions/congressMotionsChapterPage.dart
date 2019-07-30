import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/congress/motions/motion.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lokalsamhallesappen/general/colors.dart';
import 'package:lokalsamhallesappen/general/navigationScreen.dart';
import 'package:page_transition/page_transition.dart';

class CongressMotionsChapterPageWidget extends StatefulWidget {
  final List<Motion> motions;

  CongressMotionsChapterPageWidget(
      {
        Key key,
        @required this.motions,
      }
      ) : super(key: key
  );

  @override
  State<StatefulWidget> createState() {
    return CongressMotionsChapterPageWidgetState();
  }
}

class CongressMotionsChapterPageWidgetState extends State<CongressMotionsChapterPageWidget>{
  List<Motion> downloading = new List();

  @override
  Widget build(BuildContext context) {
    return NavigationScreen(
      backgroundImage: AssetImage("images/motions_background.jpg"),
      children: buildNavigationCards(),
    );
  }

  List<Widget> buildNavigationCards(){
    List<Widget> widgets = new List();
    widget.motions.forEach((m) => widgets.add(GestureDetector(
        child: buildMotionCard(m, FontAwesomeIcons.fileAlt),
        onTap: () => launchPdf(m)
    )));
    return widgets;
  }

  Widget buildMotionCard(Motion motion, IconData leadingIcon) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(5)
        ),
        margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
        child: ListTile(
          leading: Icon(
              leadingIcon,
              color: CufColors.mainColor),
          trailing: getDownloadStatus(motion),
          title: Text(
            motion.title,
            style: TextStyle(
                color: CufColors.mainColor,
                fontSize: 18
            ),
            maxLines: 1,
          ),
        )
    );
  }

  Widget getDownloadStatus(Motion motion) {
    if(downloading.contains(motion)){
      return SizedBox(
        height: 17,
        width: 17,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(CufColors.mainColor),
        ),
      );
    }
    else if(DefaultCacheManager().getFileFromMemory(motion.url) == null){
      return Icon(
        FontAwesomeIcons.arrowDown,
        size: 21,
        color: CufColors.mainColor,
      );
    }
    else{
      return Icon(
        FontAwesomeIcons.check,
        size: 18,
        color: CufColors.mainColor,
      );
    }
  }

  launchPdf(Motion motion) {
    if(DefaultCacheManager().getFileFromMemory(motion.url) != null){
      DefaultCacheManager().getFileFromCache(motion.url)
          .then((file)=> openPdf(file, motion));
    }else{
      setState(() {
        downloading.add(motion);
        DefaultCacheManager().downloadFile(motion.url).then((file) => doneDownloading(file, motion));
      });
    }
  }

  openPdf(FileInfo fileInfo, Motion motion) async {

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: PDFViewerScaffold(
            appBar: AppBar(
              backgroundColor: CufColors.mainColor,
              title: Text(motion.title),
            ),
            path: fileInfo.file.path)
      )
    );
  }

  doneDownloading(FileInfo file, Motion motion) {
    setState(() {
      downloading.remove(motion);
    });
  }
}
