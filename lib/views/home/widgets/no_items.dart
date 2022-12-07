import 'package:flutter/material.dart';

import '../../../utils/constant.dart';

class NoItems extends StatelessWidget {
  const NoItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: kPaddingItemView,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sorry, There are no items yet.',
                style: textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              const Text(
                'You can add item by pressing this button',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: CustomPaint(
                painter: PressingButtonArrow(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PressingButtonArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // draw arrow
    final arrowPainter = Paint()
      ..color = Colors.indigo.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final arrow = Path()
      ..moveTo(center.dx, 0)
      ..lineTo(center.dx, size.height / 3)
      ..lineTo(size.width - 32, size.height / 3)
      ..lineTo(size.width - 32, size.height / 1.8);

    canvas.drawPath(arrow, arrowPainter);

    // draw pointer arrow
    final pointerArrowPainter = Paint()
      ..color = Colors.indigo.withOpacity(0.5)
      ..strokeWidth = 2;

    final pointerArrow = Path()
      ..moveTo(size.width - 32, size.height / 1.8)
      ..lineTo(size.width - 50, size.height / 1.8)
      ..lineTo(size.width - 32, size.height / 1.5)
      ..lineTo(size.width - 14, size.height / 1.8)
      ..close();

    canvas.drawPath(pointerArrow, pointerArrowPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
