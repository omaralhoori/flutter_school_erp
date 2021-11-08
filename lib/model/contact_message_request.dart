class ContactMessageRequest {
  late String senderName;
  late String email;
  late String subject;
  late String message;
  late String user;

  ContactMessageRequest(
      {required this.senderName,
      required this.email,
      required this.subject,
      required this.message,
      required this.user});

  ContactMessageRequest.fromJson(Map<String, dynamic> json) {
    senderName = json['sender_name'];
    email = json['email'];
    subject = json['subject'];
    message = json['message'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_name'] = this.senderName;
    data['email'] = this.email;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['user'] = this.user;
    return data;
  }
}
