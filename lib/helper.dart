
part of 'main.dart';

String validateUsername(String value) {
  if (value.isEmpty) {
    return 'Username cannot be empty';
  } else {
    if (RegExp(r'^[\_a-zA-Z0-9\.]+$').hasMatch(value)) {
      if (value.length > 30) {
        return 'Username should be no longer than 30 characters';
      }
      return '';
    } else {
      return 'Username cannot contain special characters';
    }
  }
}

//Calc for shake animation
math.Vector3 calc(AnimationController animationController){
  double progress = animationController.value;
  double offset = sin(progress * pi * 3.0); // Change 3.0 to adjust how wide the shake is
  return math.Vector3(offset * 10, 0.0,0.0); // Change 10 to adjust how fast the shake is
}

//Custom Painter for bubble tail
class Triangle extends CustomPainter {
  final Color backgroundColor;
  Triangle(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;

    var path = Path();
    path.lineTo(-4, 0);
    path.lineTo(0, 7);
    path.lineTo(4, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

