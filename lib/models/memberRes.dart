class MemberRes {
  final bool success;
  final String msg;

  MemberRes({
    this.success,
    this.msg,
  });

  factory MemberRes.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return MemberRes(
        success: false,
        msg: 'error',
      );
    }

    return MemberRes(
      success: json['success'],
      msg: json['msg'],
    );
  }
}