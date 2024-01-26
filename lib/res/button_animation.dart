import 'package:flutter/material.dart';

class PoppingImage extends StatefulWidget {
  final String imageUrl;
  final double initialSize;
  final double finalSize;
  final VoidCallback onTap;

  const PoppingImage({
    Key? key,
    required this.imageUrl,
    required this.initialSize,
    required this.finalSize,
    required this.onTap,
  }) : super(key: key);

  @override
  _PoppingImageState createState() => _PoppingImageState();
}

class _PoppingImageState extends State<PoppingImage> {
  double imageSize = 0.0;

  @override
  void initState() {
    super.initState();
    imageSize = widget.initialSize;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          imageSize = widget.finalSize;
        });

        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            imageSize = widget.initialSize;
            widget.onTap();
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: imageSize,
        height: 80,
        child: Image.asset(
          widget.imageUrl,
        ),
      ),
    );
  }
}
