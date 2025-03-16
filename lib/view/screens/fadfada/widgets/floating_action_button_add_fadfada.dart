import 'package:flutter/material.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';

import '../../../../routs/routs_names.dart';

class FloatingActionButtonAddFadfada extends StatelessWidget {
  const FloatingActionButtonAddFadfada({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        locator<NavigationService>().navigateTo(RouteName.ADD_FADFADA_SCREEN);
      },
      backgroundColor: Theme.of(context).iconTheme.color,
      elevation: 6.0,
      tooltip: 'إضافة فضفضة جديدة',
      child: const Icon(Icons.add, size: 28),
    );
  }
}
