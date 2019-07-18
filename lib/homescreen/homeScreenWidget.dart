import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageWidgetState();
  }
}

class HomePageWidgetState extends State<HomePageWidget> {
  Color cufGreen = Color.fromRGBO(60, 90, 153, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Box decoration takes a gradient
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Color.fromRGBO(001, 106, 058, 0.7), BlendMode.srcOver),
              image: AssetImage("images/home_background.jpg")
          )
      ),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            createCard("Bli medlem",
                "Vill du också vara med och förändra världen? Bli medlem idag!",
                Color.fromRGBO(172, 202, 87, 1),
                Icons.people,
                "https://cuf.se/bli-medlem"),
            createCard("Facebook",
                "Likea oss för att bli uppdaterad om våra aktiviteter och politiska utspel.",
                Color.fromRGBO(66, 103, 178, 1),
                FontAwesomeIcons.facebook,
                "https://www.facebook.com/cufswe/"),
            createCard("Twitter",
                "Följ oss på Twitter!",
                Color.fromRGBO(56, 161, 243, 1),
                FontAwesomeIcons.twitter,
                "https://twitter.com/cuf")
          ],
        ),
      ),
    );
  }

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget createCard(String title, String text, Color color, IconData icon, String url){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(25, 3, 25, 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white.withOpacity(0.9)
        ),
        height: 150,
        child: Center(
          child: ListTile(
            leading: Icon(
              icon,
              color: color,
              size: 60,
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 25,
                  color: color
              ),
            ),
            subtitle: Text(
              text,
              style: TextStyle(
                  fontSize: 15,
                  color: color
              ),
            ),
          ),
        ),
      ),
      onTap: () => _launchURL(url),
    );
  }
}