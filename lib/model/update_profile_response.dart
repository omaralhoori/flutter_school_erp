class UpdateProfileResponse {
  late String? message;
  late String? errorMessage;

  UpdateProfileResponse({this.message, this.errorMessage});

  UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorMessage = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['error'] = this.errorMessage;
    return data;
  }
}
