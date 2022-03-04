class Comment {
  late String userName;
  late String name;
  late String comment;
  late String? userImage;
  late int isOwned;

  Comment(
      {required this.userName,
      required this.name,
      required this.comment,
      required this.isOwned,
      this.userImage});

  Comment.fromJson(dynamic json) {
    userName = json['user_name'];
    name = json['name'];
    comment = json['comment'];
    isOwned = json['is_owned'];
    userImage = json['user_image'];
  }
}
