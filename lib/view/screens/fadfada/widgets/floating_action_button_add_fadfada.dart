import 'package:flutter/material.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:provider/provider.dart';
import '../view_model/fadfada_view_model.dart';
class FloatingActionButtonAddFadfada extends StatelessWidget {
  const FloatingActionButtonAddFadfada({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FadfadaViewModel>(
      builder: (context, viewModel, child) {
        return FloatingActionButton(
          onPressed: () async {
           viewModel.navigateToAddFadfada();
          },
          backgroundColor: Theme.of(context).iconTheme.color,
          elevation: 6.0,
          tooltip: 'إضافة فضفضة جديدة',
          child: const Icon(Icons.add, size: 28),
        );
      },
    );
  }
}
