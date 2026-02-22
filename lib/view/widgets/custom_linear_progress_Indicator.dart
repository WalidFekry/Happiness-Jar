import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator({
    this.visible = true,
    this.height = 5,
    super.key,
  });

  final bool visible;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Center(
      child: LinearProgressIndicator(
        minHeight: height,
        backgroundColor: Theme.of(context).iconTheme.color,
      ),
    );
  }
}