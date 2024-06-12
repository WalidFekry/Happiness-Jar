import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/profile/view_model/profile_view_model.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../services/assets_manager.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/app_name_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return BaseView<ProfileViewModel>(
        onModelReady: (viewModel) {
          viewModel.getUserData();
        },
        builder: (context, viewModel, child) {
          return Scaffold(
              appBar: AppBar(
                title: const AppBarTextWidget(
                  title: "حسابي الشخصي",
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(AssetsManager.iconAppBar),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        locator<NavigationService>().goBack();
                      },
                      icon: Icon(
                        IconlyLight.arrow_left_2,
                        size: 35,
                        color: Theme.of(context).iconTheme.color,
                      ))
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      Colors.grey,
                                  width: 2),
                              image: DecorationImage(
                                image: viewModel.image != null ? FileImage(viewModel.image!) : const AssetImage(AssetsManager.iconAppBar) as ImageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextWidget(label: "مرحباً يا ${viewModel.userName} 🦋"),
                              const SubtitleTextWidget(
                                  label: "اتمنى ان تكون بخير 💙"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          const SubtitleTextWidget(label: "اعدادات التطبيق"),
                          const SizedBox(
                            height: 7,
                          ),
                          SwitchListTile(
                            secondary: Image.asset(
                              AssetsManager.darkMode,
                              height: 40,
                            ),
                            title: ContentTextWidget(label: themeProvider.getIsDarkTheme
                                ? "الوضع الليلي"
                                : "الوضع النهاري",),
                            value: themeProvider.getIsDarkTheme,
                            onChanged: (value) {
                              themeProvider.setDarkTheme(themeValue: value);
                            },
                          ),
                          const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          const SubtitleTextWidget(label: "المزيد .."),
                          const SizedBox(
                            height: 7,
                          ),
                          const ListTile(
                            title: ContentTextWidget(label: 'صفحتنا على الفيسبوك',),
                            leading: Icon(Icons.facebook),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const ListTile(
                            title: ContentTextWidget(label: 'صفحتنا على الفيسبوك',),
                            leading: Icon(Icons.facebook),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const ListTile(
                            title: ContentTextWidget(label: 'صفحتنا على الفيسبوك',),
                            leading: Icon(Icons.facebook),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const ListTile(
                            title: ContentTextWidget(label: 'صفحتنا على الفيسبوك',),
                            leading: Icon(Icons.facebook),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
