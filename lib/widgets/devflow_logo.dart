import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DevFlowLogo extends StatelessWidget {
  const DevFlowLogo({
    super.key,
    this.size = 36,
    this.showName = true,
    this.textColor = Colors.white,
  });
  final double size;
  final bool showName;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final nameSize = size * .58;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * .32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .16),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            'DF',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: size * .34,
              letterSpacing: .4,
            ),
          ),
        ),
        if (showName) ...[
          SizedBox(width: size * .24),
          Text(
            'DevFlow',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: nameSize,
              fontWeight: FontWeight.w700,
              letterSpacing: .4,
            ),
          ),
        ],
      ],
    );
  }
}
