class UserData {
  late String fullName;
  late String email;
  late String? password;
  late String? userImage;

  UserData({
    required this.fullName,
    required this.email,
    this.password,
    this.userImage,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullname'] = this.fullName;
    data['email'] = this.email;
    if (this.password != null) {
      data['password'] = this.password;
    }
    return data;
  }
}
