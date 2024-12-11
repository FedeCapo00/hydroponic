import 'package:flutter/material.dart';

class Thermo extends ImplicitlyAnimatedWidget {
  const Thermo({
    super.key,
    super.curve,
    required this.color,
    required this.value,
    required this.maxValue,
    required super.duration,
    this.width = 18.0,
    this.height = 63.0,
    this.textStyle,
    super.onEnd,
  });

  final Color color;
  final double value;
  final double width;
  final double height;
  final double maxValue;
  final TextStyle? textStyle;

  @override
  AnimatedWidgetBaseState<Thermo> createState() => _ThermoState();
}

class _ThermoState extends AnimatedWidgetBaseState<Thermo> {
  ColorTween? _color;
  Tween<double>? _value;
  static const _kFontFam = 'CustomIcon';
  static const String? _kFontPkg = null;
  bool celsius = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FittedBox(
        child: Column(
          children: [
            Row(
              children: [
                CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: _ThermoPainter(
                    color: _color!.evaluate(animation)!,
                    value: _value!.evaluate(animation).clamp(0.0, 1.0),
                  ),
                ),

                // Spacing
                const SizedBox(width: 8),

                Column(
                  children: [
                    Text(
                      "Actual Temperature:",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 6, 77, 110),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${celsius ? (_value!.evaluate(animation) * widget.maxValue).toStringAsFixed(1) : ((_value!.evaluate(animation) * widget.maxValue) * 9 / 5 + 32).toStringAsFixed(1)} ${celsius ? "°C" : "°F"}',
                      style: widget.textStyle ??
                          const TextStyle(
                            fontSize: 14,
                            //color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            IconData(0xe800,
                                fontFamily: _kFontFam, fontPackage: _kFontPkg),
                          ),
                          hoverColor: const Color.fromARGB(255, 174, 181, 174)
                              .withOpacity(1),
                          onPressed: () {
                            setState(() {
                              celsius = false;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            IconData(0xe801,
                                fontFamily: _kFontFam, fontPackage: _kFontPkg),
                          ),
                          hoverColor: const Color.fromARGB(255, 174, 181, 174)
                              .withOpacity(1),
                          onPressed: () {
                            setState(() {
                              celsius = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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

class _ThermoPainter extends CustomPainter {
  _ThermoPainter({
    required this.color,
    required this.value,
  });

  final Color color;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    const bulbRadius = 6.0;
    const smallRadius = 3.0;
    const border = 1.0;

    final rect = Offset.zero & size;
    final innerRect = rect.deflate(size.width / 2 - bulbRadius);

    final r1 = Alignment.bottomCenter.inscribe(
      const Size(2 * smallRadius, bulbRadius * 2),
      innerRect,
    );

    final r2 = Alignment.center.inscribe(
      Size(2 * smallRadius, innerRect.height),
      innerRect,
    );

    final bulb = Path()
      ..addOval(Alignment.bottomCenter
          .inscribe(Size.square(innerRect.width), innerRect));

    final outerPath = Path()
      ..addOval(
        Alignment.bottomCenter
            .inscribe(Size.square(innerRect.width), innerRect)
            .inflate(border),
      )
      ..addRRect(
        RRect.fromRectAndRadius(r2, const Radius.circular(smallRadius))
            .inflate(border),
      );

    final valueRect = Rect.lerp(r1, r2, value)!;
    final valuePaint = Paint()..color = color;

    canvas
      ..save()
      ..drawPath(
        outerPath.shift(const Offset(1, 1)),
        Paint()
          ..color = Colors.black54
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      )
      ..clipPath(outerPath)
      ..drawPaint(Paint()..color = Color.alphaBlend(Colors.white60, color))
      ..drawPath(bulb, valuePaint)
      ..drawRRect(
        RRect.fromRectAndRadius(valueRect, const Radius.circular(smallRadius)),
        valuePaint,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _ThermoPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.value != value;
  }
}
