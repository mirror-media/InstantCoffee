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
      postId = 'test';
    }
    // test data
    String title = postId;
    String photoUrl = 'https://www.mirrormedia.com.tw/assets/images/20210317185015-013b905320686dea9abf085902f36118-mobile.png';
    String slug = '20210128pol001';
    return SubscribedArticle(
        oneTimeEndDatetime: oneTimeEndDatetime,
        postId: postId,
        title: title,
        photoUrl: photoUrl,
        slug: slug
      );
  }
}
