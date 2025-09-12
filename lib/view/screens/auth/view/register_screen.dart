import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/assets_manager.dart';
import 'package:happiness_jar/view/screens/auth/view_model/register_view_model.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';
import 'package:iconly/iconly.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/spacing.dart';
import '../../../../helpers/validators.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../base_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      onModelReady: (viewModel) {
        viewModel.setDoneGetStarted();
      },
      onFinish: (viewModel) {
        viewModel.destroy();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 75.0),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        AssetsManager.registerJar,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                      verticalSpace(15),

                      const TitleTextWidget(
                        label: "مرحباً بك في تطبيق برطمان السعادة",
                        fontSize: 18,
                      ),
                      verticalSpace(30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SubtitleTextWidget(label: "اختار صورة من هنا"),
                          Icon(
                            IconlyBold.arrow_left_2,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          GestureDetector(
                            onTap: viewModel.pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                radius: 40,
                                backgroundImage: viewModel.image != null
                                    ? FileImage(viewModel.image!)
                                    : null,
                                child: viewModel.image == null
                                    ? Icon(Icons.add_a_photo,
                                        size: 40,
                                        color:
                                            Theme.of(context).iconTheme.color)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(15),

                      TextFormField(
                        maxLength: 20,
                        controller: viewModel.nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: Validators.validateUserName,
                        decoration: InputDecoration(
                          labelText: 'واكتب اسمك هنا ..',
                          prefixIcon: Icon(
                            IconlyLight.add_user,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                      verticalSpace(20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1999, 8, 19),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  viewModel.setBirthDate(pickedDate);
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: viewModel.birthDateController,
                                  validator: (value) =>
                                      Validators.validateBirthDate(
                                          viewModel.birthDate),
                                  decoration: InputDecoration(
                                    labelText: 'اختياري: تاريخ ميلادك ..',
                                    prefixIcon: Icon(
                                      Icons.cake_outlined,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          horizontalSpace(8),
                          IconButton(
                            icon: Icon(Icons.info_outline,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (_) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          verticalSpace(10),
                                          const SubtitleTextWidget(
                                            label:
                                                "ليه بحب أعرف تاريخ ميلادك؟ 🎂",
                                          ),
                                          verticalSpace(10),
                                          const ContentTextWidget(
                                            label: AppConstants.birthdayInfo,
                                            fontSize: 16,
                                          ),
                                          verticalSpace(10),
                                          CustomElevatedButton(
                                            label: "تمام",
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            backgroundColor: Theme.of(context).iconTheme.color,
                                            textColor: Theme.of(context).primaryColor,
                                            horizontal: 30,
                                            vertical: 10,
                                          ),
                                          verticalSpace(10),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      verticalSpace(30),

                      CustomElevatedButton(
                        label: "تسجيل الدخول",
                        onPressed: () {
                          if (!viewModel.formKey.currentState!.validate()) {
                            return;
                          }
                          viewModel.saveData();
                        },
                        backgroundColor: Theme.of(context).iconTheme.color,
                        textColor: Theme.of(context).primaryColor,
                        shadowColor: Theme.of(context).cardColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
