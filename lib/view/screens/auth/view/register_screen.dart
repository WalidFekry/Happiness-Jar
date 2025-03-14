import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/assets_manager.dart';
import 'package:happiness_jar/view/screens/auth/view_model/register_view_model.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';
import 'package:iconly/iconly.dart';

import '../../../../helpers/spacing.dart';
import '../../../../helpers/validators.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../base_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                                      color: Theme.of(context).iconTheme.color)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(15),
                    Form(
                      key: viewModel.formKey,
                      child: TextFormField(
                        maxLength: 20,
                        controller: viewModel.nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        validator: Validators.validateUserName,
                        decoration: InputDecoration(
                          labelText: 'واكتب اسمك هنا ..',
                          prefixIcon: Icon(IconlyLight.add_user,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ),
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
        );
      },
    );
  }
}
