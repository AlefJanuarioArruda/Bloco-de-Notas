import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading:IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ) ,
          backgroundColor: Colors.black,
          title: const Text('Bloco de Notas',style: TextStyle(color: Colors.white),),

      shape: CustomShapeBorder(),
    );
  }

  @override
  // TODO: implement preferredSiz
  Size get preferredSize => Size.fromHeight(70);
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double x = 150, y = 45, r = 0.5;
    Path path = Path()
      ..addRRect(RRect.fromRectAndCorners(rect))
      ..moveTo(rect.bottomRight.dx - 30, rect.bottomCenter.dy)
      ..relativeQuadraticBezierTo(
          ((-x / 2) + (x / 6)) * (1 - r), 0, -x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(
          -x / 6 * r, y * (1 - r), -x / 2 * (1 - r), y * (1 - r))
      ..relativeQuadraticBezierTo(
          ((-x / 2) + (x / 6)) * (1 - r), 0, -x / 2 * (1 - r), -y * (1 - r))
      ..relativeQuadraticBezierTo(-x / 6 * r, -y * r, -x / 2 * r, -y * r);
    path.close();
    return path;
  }
}
