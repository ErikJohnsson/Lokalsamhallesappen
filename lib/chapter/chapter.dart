class Chapter{
  final int shortContentLength = 100;

  String title;
  String content;
  List<Chapter> subChapters;
  Chapter parent;

  Chapter(String title, String content, Chapter parent){
    this.title = title;
    this.content = content;
    this.parent = parent;
  }

  void setSubChapters(List<Chapter> subChapters){
    this.subChapters = subChapters;
  }
}