import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'colors.dart';

class PdfNavigationCard extends StatefulWidget{

  final String url;
  final IconData leadingIcon;
  final String title;

  PdfNavigationCard(
      {
        Key key,
        @required
        this.url,
        this.leadingIcon,
        this.title
      }
      ) : super(key: key
  );

  @override
  State<StatefulWidget> createState() {
    return PdfNavigationCardState();
  }
}

class PdfNavigationCardState extends State<PdfNavigationCard>{
  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(5)
            ),
            margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
            child: ListTile(
              leading: Icon(
                  widget.leadingIcon,
                  color: CufColors.mainColor),
              trailing: getDownloadStatus(),
              title: Text(
                widget.title,
                style: TextStyle(
                    color: CufColors.mainColor,
                    fontSize: 18
                ),
                maxLines: 1,
              ),
            )
        ),
        onTap: () => launchPdf()
    );
  }

  Widget getDownloadStatus() {
    if(downloading){
      return SizedBox(
        height: 17,
        width: 17,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(CufColors.mainColor),
        ),
      );
    }
    else if(DefaultCacheManager().getFileFromMemory(widget.url) == null){
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

  launchPdf() {
    if(DefaultCacheManager().getFileFromMemory(widget.url) != null){
      DefaultCacheManager().getFileFromCache(widget.url)
          .then((file)=> openPdf(file));
    }else{
      setState(() {
        downloading = true;
        DefaultCacheManager().downloadFile(widget.url).then((file) => doneDownloading(file));
      });
    }
  }

  openPdf(FileInfo fileInfo) async {

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: PDFViewerScaffold(
                appBar: AppBar(
                  backgroundColor: CufColors.mainColor,
                  title: Text(widget.title),
                ),
                path: fileInfo.file.path)
        )
    );
  }

  doneDownloading(FileInfo file) {
    setState(() {
      downloading = false;
    });
  }
}