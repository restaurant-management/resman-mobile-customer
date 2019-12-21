class _CommentUser {
  String uuid;
  String username;
  String fullName;
  String avatar;

  _CommentUser.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    username = json['username'];
    fullName = json['fullName'];
    avatar = json['avatar'];
  }
}

class Comment {
  int id;
  DateTime createAt;
  _CommentUser createBy;
  double rating;
  String content;

  Comment.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? json['id'];
    createAt = DateTime.tryParse(json['createAt']);
    createBy = _CommentUser.fromJson(json['createBy']);
    content = json['content'];
    rating = double.tryParse(json['rating'].toString()) ?? 5;
  }
}