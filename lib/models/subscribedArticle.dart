class SubscribedArticle {
  DateTime oneTimeEndDatetime;
  String postId;
  String? title;
  String? slug;
  String? photoUrl;

  SubscribedArticle({
    required this.oneTimeEndDatetime, 
    required this.postId,
    this.title,
    this.slug,
    this.photoUrl
    });

  factory SubscribedArticle.fromJson(Map<String, dynamic> json) {
    DateTime oneTimeEndDatetime = DateTime.parse(json["oneTimeEndDatetime"]).toLocal();
    String postId = json["postId"]??'';
    
    return SubscribedArticle(
      oneTimeEndDatetime: oneTimeEndDatetime,
      postId: postId,
    );
  }
}
