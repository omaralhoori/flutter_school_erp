
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_erp/model/album.dart';

class AlbumCard extends StatelessWidget {
  final Album album;

  const AlbumCard({Key? key, required this.album})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0)
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            width: size.width * .9,
            child: Column(
              children: [
                Text(this.album.title),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${this.album.likes}",
                          style: GoogleFonts.rajdhani(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        FaIcon(
                          FontAwesomeIcons.heart,
                          size: 17,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${this.album.approvedComments}",
                          style: GoogleFonts.rajdhani(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        FaIcon(
                          FontAwesomeIcons.comment,
                          size: 17,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${this.album.views}",
                          style: GoogleFonts.rajdhani(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        FaIcon(
                          FontAwesomeIcons.eye,
                          size: 17,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}