import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/helpers/validators.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/custom_elevated_button.dart';
import '../../base_screen.dart';
import '../view_model/posts_view_model.dart';

class AddPostDialog extends StatelessWidget {
  const AddPostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<PostsViewModel>(onModelReady: (viewModel) {
      viewModel.getUserName();
      viewModel.initController();
    }, onFinish: (viewModel) {
      viewModel.disposeController();
    }, builder: (context, viewModel, child) {
      return Dialog(
          elevation: 10.0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SubtitleTextWidget(
                      label: 'اضافة اقتباس',
                      textAlign: TextAlign.center,
                      overflew: TextOverflow.ellipsis),
                  verticalSpace(10),
                  Form(
                      key: viewModel.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                              maxLength: 20,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              controller: viewModel.userNameController,
                              decoration: InputDecoration(
                                suffixIcon: viewModel
                                        .userNameController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () => viewModel.clearUserName(),
                                        child: Icon(IconlyLight.close_square,
                                            color: Theme.of(context).cardColor),
                                      )
                                    : null,
                                prefixIcon: Icon(IconlyLight.user,
                                    color: Theme.of(context).iconTheme.color),
                                labelText: 'إسمك',
                              ),
                              validator: Validators.validateUserName),
                          verticalSpace(15),
                          TextFormField(
                            maxLines: 5,
                            minLines: 2,
                            maxLength: 300,
                            maxLengthEnforcement: MaxLengthEnforcement
                                .truncateAfterCompositionEnds,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            controller: viewModel.postController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(IconlyLight.paper,
                                  color: Theme.of(context).iconTheme.color),
                              suffixIcon: viewModel
                                      .postController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => viewModel.clearPost(),
                                      child: Icon(IconlyLight.close_square,
                                          color: Theme.of(context).cardColor),
                                    )
                                  : null,
                              labelText: 'اقتباس, حالة, كتابة',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'من فضلك قم بكتابة اقتباس ⚠️';
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                  verticalSpace(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !viewModel.isLoadingAddPost
                          ? CustomElevatedButton(
                              label: "إضافة",
                              onPressed: () async {
                                if (!viewModel.formKey.currentState!
                                    .validate()) {
                                  return;
                                }
                                var result = await viewModel.addPost();
                                if (result) {
                                  viewModel.goBack();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      CustomSnackBar.success(
                                        backgroundColor:
                                            Theme.of(context).iconTheme.color!,
                                        message:
                                            "تم إرسال الاقتباس بنجاح للمراجعة\nسوف تتلقى إشعارًا عند الموافقة.",
                                        icon: Icon(
                                          Icons.access_alarm,
                                          color: Theme.of(context).cardColor,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  });
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      CustomSnackBar.error(
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        message:
                                            "حدث خطأ أثناء أرسال الاقتباس.",
                                        icon: Icon(
                                          Icons.error,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  });
                                }
                              },
                              backgroundColor:
                                  Theme.of(context).iconTheme.color,
                              textColor: Theme.of(context).primaryColor,
                              horizontal: 20,
                              vertical: 10,
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: CircularProgressIndicator(
                                backgroundColor:
                                    Theme.of(context).iconTheme.color,
                                strokeAlign: 5,
                                strokeWidth: 5,
                              ),
                            ),
                      horizontalSpace(10),
                      CustomElevatedButton(
                        label: "إغلاق",
                        onPressed: () {
                          viewModel.goBack();
                        },
                        backgroundColor: Theme.of(context).cardColor,
                        textColor: Theme.of(context).primaryColor,
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
