import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';

class NavigationScreen extends StatefulWidget{

  final List<Widget> children;
  final AssetImage backgroundImage;
  final bool showLoading;

  NavigationScreen(
      {
        Key key,
        @required
        this.children,
        this.backgroundImage,
        this.showLoading = false
      }
      ) : super(key: key
  );

  @override
  State<StatefulWidget> createState() {
    return NavigationScreenState();
  }
}

class NavigationScreenState extends State<NavigationScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(CufColors.mainColor.withOpacity(0.7), BlendMode.srcOver),
                image: widget.backgroundImage
            )
        ),
        child: SafeArea(
          child: Center(
            child: widget.showLoading == true
                ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.9)))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.children.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widget.children[index];
                    },
                ),
          ),
        ),
      ),
    );
  }
}