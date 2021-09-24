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
    DateTime oneTimeEndDatetime = DateTime.now();
    if(json["oneTimeEndDatetime"] != null){
      oneTimeEndDatetime = DateTime.parse(json["oneTimeEndDatetime"]);
    }
    else{
      oneTimeEndDatetime = DateTime.utc(2021,1,1);
    }
    String postId;
    if(json["postId"] != null){
      postId = json["postId"];
    }
    else{
      postId = '';
    }
    
    return SubscribedArticle(
        oneTimeEndDatetime: oneTimeEndDatetime,
        postId: postId,
      );
  }
}
