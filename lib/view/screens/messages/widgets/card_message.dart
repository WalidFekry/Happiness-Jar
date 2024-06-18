import 'package:flutter/material.dart';
import 'package:happiness_jar/services/assets_manager.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

class CardMessageWidget extends StatelessWidget {
  const CardMessageWidget(
      {Key? key, required this.body, required this.imageUrl})
      : super(key: key);

  final String? imageUrl;
  final String? body;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            image: DecorationImage(
              image: imageUrl == null
                  ? const AssetImage(AssetsManager.imageJar30)
                      as ImageProvider<Object>
                  : NetworkImage(imageUrl!) as ImageProvider<Object>,
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SubtitleTextWidget(
              label: body,
              textAlign: TextAlign.center,
              color: Colors.black,
            ),
          ),
        ));
  }
}
