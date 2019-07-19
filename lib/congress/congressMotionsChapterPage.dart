import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lokalsamhallesappen/congress/motion.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

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
  Color cufDarkGreen = Color.fromRGBO(001, 106, 058, 1);
  List<Motion> downloading = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Color.fromRGBO(001, 106, 058, 0.7), BlendMode.srcOver),
                image: AssetImage("images/motions_background.jpg")
            )
        ),
        alignment: Alignment.center,
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.motions.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  child: buildMotionCard(widget.motions[index], FontAwesomeIcons.newspaper),
                  onTap: () => launchPdf(widget.motions[index])
              );
            },
          ),
        ),
      ),
    );
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
              color: cufDarkGreen),
          trailing: getDownloadStatus(motion),
          title: Text(
            motion.title,
            style: TextStyle(
                color: cufDarkGreen,
                fontSize: 18
            ),
            maxLines: 1,
          ),
        )
    );
  }

  Widget getDownloadStatus(Motion motion) {
    if(downloading.contains(motion)){
      return CircularProgressIndicator();
    }
    else if(DefaultCacheManager().getFileFromMemory(motion.url) == null){
      return Icon(
        FontAwesomeIcons.arrowCircleDown,
        color: cufDarkGreen,
      );
    }
    else{
      return Icon(
        FontAwesomeIcons.checkCircle,
        color: cufDarkGreen,
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
      MaterialPageRoute(
          builder: (context) => PDFViewerScaffold(
              appBar: AppBar(
                backgroundColor: cufDarkGreen,
                title: Text(motion.title),
              ),
              path: fileInfo.file.path)),
    );
  }

  doneDownloading(FileInfo file, Motion motion) {
    setState(() {
      downloading.remove(motion);
    });
  }
}
