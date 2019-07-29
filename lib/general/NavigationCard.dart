import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';

class NavigationCard extends StatefulWidget{

  final Function onTap;
  final String title;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final double fontSize;

  NavigationCard(
      {
        Key key,
        @required
        this.onTap,
        this.title,
        this.leadingIcon,
        this.trailingIcon,
        this.fontSize
      }
      ) : super(key: key
  );

  @override
  State<StatefulWidget> createState() {
    return NavigationCardState();
  }
}

class NavigationCardState extends State<NavigationCard>{
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
              trailing:
              Icon(
                  widget.trailingIcon,
                  color: CufColors.mainColor),
              title: Text(
                widget.title,
                style: TextStyle(
                    color: CufColors.mainColor,
                    fontSize: widget.fontSize == null ? 20 : widget.fontSize
                ),
                maxLines: 1,
              ),
            )
        ),
        onTap:() => widget.onTap()
    );
  }
}