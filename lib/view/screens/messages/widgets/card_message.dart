import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/services/assets_manager.dart';


class CardMessageWidget extends StatelessWidget {
  const CardMessageWidget({Key? key, required this.color}) : super(key: key);

  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.blue),
        image: DecorationImage(image: AssetImage(AssetsManager.imageJar30),
          fit: BoxFit.contain,),
          borderRadius: BorderRadius.circular(15)
      ),
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: AutoSizeText(
            "test test test",
            style: TextStyle(fontSize: 18, fontFamily: "avenir_bold"),
            maxLines: 20,
          ),
        ),
      )
    );
  }
}
