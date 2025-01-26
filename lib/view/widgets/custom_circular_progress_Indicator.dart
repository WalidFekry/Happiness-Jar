import 'package:flutter/material.dart';
class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({required this.visible,super.key});
  final bool visible;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: visible,
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).iconTheme.color,
          strokeAlign: 5,
          strokeWidth: 5,
        ),
      ),
    );
  }
}
