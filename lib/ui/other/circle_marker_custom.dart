import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/state.dart';
import 'package:latlong2/latlong.dart' hide Path;

class CircleMarker {
  final Key? key;
  final LatLng point;
  final double radius;
  final double radiusMiniCircle;
  final Color colorMiniCircle;
  final int tick360;
  final Color color;
  final bool reverse;
  final double borderStrokeWidth;
  final Color borderColor;
  final bool useRadiusInMeter;
  Offset offset = Offset.zero;
  double realRadius = 0;

  CircleMarker({
    required this.point,
    required this.radius,
    this.key,
    this.radiusMiniCircle = 200,
    this.tick360 = 8,
    this.reverse = false,
    this.colorMiniCircle = const Color(0xFF78A800),
    this.useRadiusInMeter = false,
    this.color = const Color(0xFF78A800),
    this.borderStrokeWidth = 0.0,
    this.borderColor = const Color(0xFFFFFF00),
  });
}

class CircleLayer extends StatelessWidget {
  final List<CircleMarker> circles;
  const CircleLayer({
    super.key,
    this.circles = const [],
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints bc) {
        final size = Size(bc.maxWidth, bc.maxHeight);
        final map = FlutterMapState.of(context);
        final circleWidgets = <Widget>[];
        for (final circle in circles) {
          circle.offset = map.getOffsetFromOrigin(circle.point);

          if (circle.useRadiusInMeter) {
            final r = const Distance().offset(circle.point, circle.radius, 180);
            final delta = circle.offset - map.getOffsetFromOrigin(r);
            circle.realRadius = delta.distance;
          }

          circleWidgets.add(
            CustomPaint(
              key: circle.key,
              painter: CirclePainter(circle),
              size: size,
            ),
          );
        }

        return Stack(
          children: circleWidgets,
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final CircleMarker circle;
  CirclePainter(this.circle);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green.withOpacity(0.5); //circle.color;

    _paintCircle(
      canvas,
      circle.offset,
      circle.offset,
      //circle.useRadiusInMeter ? circle.realRadius : circle.radius,
      circle.realRadius,
      circle.radiusMiniCircle,
      paint,
      circle.tick360,
      circle.reverse,
    );

    if (circle.borderStrokeWidth > 0) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = circle.borderColor
        ..strokeWidth = circle.borderStrokeWidth;

      _paintCircle(
        canvas,
        circle.offset,
        circle.offset,
        //circle.useRadiusInMeter ? circle.realRadius : circle.radius,
        circle.realRadius,
        circle.radiusMiniCircle,
        paint,
        circle.tick360,
        circle.reverse,
      );
    }
  }

  void _paintCircle(
    Canvas canvas,
    Offset offset,
    Offset offset2,
    double radius,
    double radius2,
    Paint paint,
    int tick360,
    bool reverse,
  ) {
    canvas.drawCircle(offset, radius, paint);
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red.withOpacity(0.5);
    //314.21854665130377 585.0431998223066
    // print("${offset2.dx} ${offset2.dy}");

    // var size = Size(50, 50);

    // const width = 4.0;
    // const radius = 20.0;
    // const tRadius = 2 * radius;
    // final rect = Rect.fromLTWH(
    //   width,
    //   width,
    //   size.width - 2 * width,
    //   size.height - 2 * width,
    // );
    // final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    // const clippingRect0 = Rect.fromLTWH(
    //   0,
    //   0,
    //   tRadius,
    //   tRadius,
    // );
    // final clippingRect1 = Rect.fromLTWH(
    //   size.width - tRadius,
    //   0,
    //   tRadius,
    //   tRadius,
    // );
    // final clippingRect2 = Rect.fromLTWH(
    //   0,
    //   size.height - tRadius,
    //   tRadius,
    //   tRadius,
    // );
    // final clippingRect3 = Rect.fromLTWH(
    //   size.width - tRadius,
    //   size.height - tRadius,
    //   tRadius,
    //   tRadius,
    // );

    // final path = Path()
    //   ..addRect(clippingRect0)
    //   ..addRect(clippingRect1)
    //   ..addRect(clippingRect2)
    //   ..addRect(clippingRect3);

    // canvas.clipPath(path);
    // canvas.drawRRect(
    //   rrect,
    //   Paint()
    //     ..color = Colors.pink
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = width,
    // );

    // final Paint paint22 = Paint()
    // ..strokeWidth = 60.0 // 1.
    // ..style = PaintingStyle.fill // 2.
    // ..color = Colors.pink; // 3.

    // double degToRad(double deg) => deg * (pi / 180.0);

    // final path = Path()
    //   ..addOval(
    //     Rect.fromCenter(
    //       center: Offset(offset.dx -20, offset.dy-20),
    //       height: (radius/2),
    //       width: (radius/2),
    //     ),
    //   )
    //   ..lineTo(offset.dx , offset.dy)
    //   // ..arcTo(
    //   //   // 4.
    //   //   Rect.fromCenter(
    //   //     center: Offset(offset.dx, offset.dy),
    //   //     height: (radius),
    //   //     width: (radius),
    //   //   ), // 5.
    //   //   degToRad(90), // 6.
    //   //   degToRad(120), // 7.
    //   //   false,
    //   // )
    //   // ..addOval(Rect.fromCenter(
    //   //     center: Offset(offset.dx - degToRad(radius), offset.dx - degToRad(radius)),
    //   //     height: (radius/2),
    //   //     width: (radius/2),
    //   //   ), )
    //   ..addArc(
    //     Rect.fromCenter(
    //       center: Offset(offset.dx - 30, offset.dx - 30),
    //       height: (radius / 2),
    //       width: (radius / 2),
    //     ),
    //     degToRad(180),
    //     degToRad(90),
    //   );

    // canvas.drawPath(path, paint22); // 8.
    // for (var i = 0; i < 360; i += 6) {
    // canvas.drawCircle(
    //   Offset(offset.dx, offset.dy) +
    //       Offset(radius - (radius2), radius - (radius2)),
    //   radius / 2,
    //   paint2,
    // );
    final sss = tick360 ;
    /// Меняем направление стреклки
    double  ttt = (radius/2 + radius/4 );
    //reverse
    if(reverse){
      ttt = -(radius/2 + radius/4 );
    }
    
    _arrow(
      canvas,
      Offset(offset.dx, offset.dy) +
          Offset(radius * cos(tick360), radius * sin(tick360)),
      Offset(offset.dx, offset.dy) +
          Offset(radius  * cos(sss)  + ttt * sin(sss)  + cos(sss),
           radius * sin(sss) - ttt * cos(sss)   + cos(sss) , 
          ),
      0,
      0,
      (radius / 4).toInt(),
    );
    canvas.drawCircle(
      Offset(offset.dx, offset.dy) +
          Offset(radius * cos(tick360), radius * sin(tick360)),
      radius / 2,
      paint2,
    );
    // }
  }

  _arrow(Canvas canvas, Offset offset , Offset offset2,  int anglew, int lenghtLine, int arrowSized) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final p1 = offset;
    final p2 = Offset(offset2.dx , offset2.dy );

    // canvas.drawLine(p1, p2, paint);

    final dX = p2.dx - p1.dx;
    final dY = p2.dy - p1.dy;
    final angle = atan2(dY, dX);

    final arrowSize = arrowSized;
    final arrowAngle = 50 * pi / 180;

    final path = Path();

    path.moveTo(p2.dx - arrowSize * cos(angle - arrowAngle),
        p2.dy - arrowSize * sin(angle - arrowAngle));
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p2.dx - arrowSize * cos(angle + arrowAngle),
        p2.dy - arrowSize * sin(angle + arrowAngle));
    path.close();
    canvas.drawPath(path, paint);
  }

  Offset toPolar(Offset center, int radians, double radius) {
    return center +
        Offset(radius * cos(radians.radians), radius * sin(radians.radians));
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => false;
}

extension NumX<T extends num> on T {
  double get radians => (this * pi) / 180.0;
}

class MyPainter extends CustomPainter {
  MyPainter(this.sweepAngle, this.color);
  final double? sweepAngle;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 60.0 // 1.
      ..style = PaintingStyle.stroke // 2.
      ..color = color!; // 3.

    double degToRad(double deg) => deg * (pi / 180.0);

    final path = Path()
      ..arcTo(
          // 4.
          Rect.fromCenter(
            center: Offset(size.height / 2, size.width / 2),
            height: size.height,
            width: size.width,
          ), // 5.
          degToRad(180), // 6.
          degToRad(sweepAngle!), // 7.
          false);

    canvas.drawPath(path, paint); // 8.
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
