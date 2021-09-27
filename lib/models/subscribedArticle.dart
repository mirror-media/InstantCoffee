class SubscribedArticle {
  DateTime oneTimeEndDatetime;
  String postId;
  String title;
  String slug;
  String photoUrl;

  SubscribedArticle({
    this.oneTimeEndDatetime, 
    this.postId,
    this.title,
    this.slug,
    this.photoUrl
    });

  factory SubscribedArticle.fromJson(Map<String, dynamic> json) {
    DateTime oneTimeEndDatetime = DateTime.parse(json["oneTimeEndDatetime"])??DateTime.utc(2021,1,1);
    String postId = json["postId"]??'';
    
    return SubscribedArticle(
        oneTimeEndDatetime: oneTimeEndDatetime,
        postId: postId,
      );
  }
}
