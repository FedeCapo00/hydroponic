import 'package:flutter/material.dart';

class Humidity extends ImplicitlyAnimatedWidget {
  const Humidity({
    super.key,
    super.curve,
    required this.color,
    required this.value,
    required this.maxValue,
    required super.duration,
    this.size = 60.0,
    this.textStyle,
    super.onEnd,
  });

  final Color color;
  final double value;
  final double maxValue;
  final double size;
  final TextStyle? textStyle;

  @override
  AnimatedWidgetBaseState<Humidity> createState() => _HumidityState();
}

class _HumidityState extends AnimatedWidgetBaseState<Humidity> {
  ColorTween? _color;
  Tween<double>? _value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size * 1.5),
            painter: _HumidityPainter(
              color: _color!.evaluate(animation)!,
              value: _value!.evaluate(animation).clamp(0.0, 1.0),
            ),
          ),

          // Spacing
          const SizedBox(height: 8),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Actual Humidity:",
                style: const TextStyle(
                  color: Color.fromARGB(255, 6, 77, 110),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(_value!.evaluate(animation) * widget.maxValue).toStringAsFixed(1)}%',
                style: widget.textStyle ??
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(_color, widget.color, (dynamic v) => ColorTween(begin: v))
        as ColorTween?;
    _value =
        visitor(_value, widget.value, (dynamic v) => Tween<double>(begin: v))
            as Tween<double>?;
  }
}

class _HumidityPainter extends CustomPainter {
  _HumidityPainter({
    required this.color,
    required this.value,
  });

  final Color color;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.4,
        size.width / 2,
        size.height,
      )
      ..quadraticBezierTo(
        size.width * 0.15,
        size.height * 0.4,
        size.width / 2,
        0,
      );

    // Save canvas state and clip to the water droplet path
    canvas.save();
    canvas.clipPath(path);

    // Draw the filled level inside the water droplet
    final levelHeight = size.height * value;
    final fillRect =
        Rect.fromLTWH(0, size.height - levelHeight, size.width, levelHeight);
    final fillPaint = Paint()..color = color.withOpacity(0.7);
    canvas.drawRect(fillRect, fillPaint);

    // Restore canvas to avoid clipping other elements
    canvas.restore();

    // Draw the water droplet outline
    final outlinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant _HumidityPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.value != value;
  }
}
