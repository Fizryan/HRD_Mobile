import 'package:flutter/material.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/variables/color_data.dart';

// #region decoration
class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    Path path = Path();

    path.moveTo(0, h * 0.25);

    path.cubicTo(w * 0.1, 0, w * 0.45, 0, w * 0.55, h * 0.20);

    path.cubicTo(w * 0.75, h * 0.45, w, h * 0.35, w, h * 0.55);

    path.cubicTo(w, h * 0.75, w * 0.65, h * 1.05, w * 0.45, h * 0.85);

    path.cubicTo(w * 0.25, h * 0.70, w * 0.1, h * 0.55, 0, h * 0.65);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant BackgroundClipper oldClipper) => false;
}
// #endregion

// #region widget
class GeneralWidget {
  Widget buildStatsHeader(List<Widget> widgetsChildrens, User user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColor.borderShadow, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widgetsChildrens,
        ),
      ),
    );
  }
}
// #endregion