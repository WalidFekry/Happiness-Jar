import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happiness_jar/helpers/common_functions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/screens/fadfada/model/fadfada_model.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

import '../../../../helpers/date_time_helper.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../base_screen.dart';
import '../view_model/fadfada_view_model.dart';

class ViewFadfadaScreen extends StatelessWidget {
  final FadfadaModel fadfada;

  const ViewFadfadaScreen({super.key, required this.fadfada});

  @override
  Widget build(BuildContext context) {
    return BaseView<FadfadaViewModel>(
        onModelReady: (viewModel) {},
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: const CustomAppBar(title: "تفاصيل الفضفضة"),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentTextWidget(
                      label: "🗂 التصنيف: ${fadfada.category}",
                    ),
                    verticalSpace(8),
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 18, color: Colors.blueGrey),
                        const SizedBox(width: 6),
                        ContentTextWidget(
                          fontSize: 12,
                          label: "تمت كتابتها بتاريخ: ${DateTimeHelper.formatTimestamp(fadfada.createdAt!)}",
                        ),
                      ],
                    ),
                    verticalSpace(8),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 18, color: Colors.blueGrey),
                        const SizedBox(width: 6),
                        ContentTextWidget(
                          fontSize: 12,
                          label: "الوقت المستغرق: ${DateTimeHelper.formatTimeSpent(fadfada.timeSpent)}",
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ContentTextWidget(
                          label: fadfada.text ?? "",
                          height: 1.5,
                        ),
                      ),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.blueGrey),
                          onPressed: () {
                            CommonFunctions.copyMessage(fadfada.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("تم نسخ النص!")),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.blueGrey),
                          onPressed: () {
                            CommonFunctions.shareMessage(fadfada.text);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}