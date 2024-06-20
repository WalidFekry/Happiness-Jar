import 'package:flutter/cupertino.dart';

import '../../../../services/assets_manager.dart';

class EmptyMessageWidget extends StatelessWidget {
  const EmptyMessageWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Image.asset(AssetsManager.imageJar30);
  }
}
