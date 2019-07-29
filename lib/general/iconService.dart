import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconService{
  static IconData getIcon(String title){
    switch(title){
      case "Demokrati":
        return FontAwesomeIcons.university;
      case "Människan":
        return FontAwesomeIcons.male;
      case "Jämställdhet":
        return FontAwesomeIcons.balanceScale;
      case "Migration och integration":
        return FontAwesomeIcons.passport;
      case "Miljö":
        return FontAwesomeIcons.tree;
      case "Utbildning":
        return FontAwesomeIcons.graduationCap;
      case "Ekonomi":
        return FontAwesomeIcons.coins;
      case "Internationellt":
      case "Internationell politik":
        return FontAwesomeIcons.globeEurope;
      case "Infrastruktur och kommunikationer":
        return FontAwesomeIcons.road;
      case "Organisation":
        return FontAwesomeIcons.users;
      case "Propositioner":
        return FontAwesomeIcons.book;
      default:
        return FontAwesomeIcons.book;
    }
  }
}