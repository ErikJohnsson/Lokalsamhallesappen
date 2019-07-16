class Schedule{

  String date;
  String title;
  List<String> activities;

  Schedule(String date, String title, String activities){
    this.date = date;
    this.title = title;
    this.activities = createActivites(activities);
  }

  List<String> createActivites(String activities) {
    List<String> split = activities.split("\$");
    return split.where((string) => string.isNotEmpty).toList();
  }

}