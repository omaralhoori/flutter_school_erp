import 'package:flutter/material.dart';
import 'package:school_erp/model/announcement.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({Key? key, required this.announcement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            width: 300,
            child: Column(
              children: [
                Text(this.announcement.title),
                this.announcement.description != null
                    ? Text(this.announcement.description!)
                    : Container(),
                this.announcement.image != null
                    ? Image.network(
                        'http://192.168.1.109:8000' + this.announcement.image!,
                        height: 150,
                        fit: BoxFit.fill,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
