import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuoteIcon extends StatelessWidget {
  final Color color;
  final double size;

  const QuoteIcon({
    super.key,
    required this.color,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/quotes_icon.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
