class CreateMemberRes {
  final bool success;
  final String msg;

  CreateMemberRes({
    this.success,
    this.msg,
  });

  factory CreateMemberRes.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return CreateMemberRes(
        success: false,
        msg: 'error',
      );
    }

    return CreateMemberRes(
      success: json['success'],
      msg: json['msg'],
    );
  }
}