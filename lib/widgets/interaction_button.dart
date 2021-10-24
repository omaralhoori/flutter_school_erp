import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_erp/config/frappe_palette.dart';

class InteractionButton extends StatelessWidget {
  const InteractionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.count,
    required this.color,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final IconData? icon;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "$count",
            style: GoogleFonts.rajdhani(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: FrappePalette.grey.shade900
            ),
          ),
          SizedBox(width: 5.0,),
          FaIcon(
            icon,
            size: 17,
            color: color,
          ),
        ],
      ),
    );
  }
}