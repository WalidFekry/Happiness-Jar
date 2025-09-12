import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/screens/profile/view_model/profile_view_model.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/custom_app_bar.dart';
import 'package:happiness_jar/view/widgets/info_dialog.dart';
import 'package:happiness_jar/view/widgets/warning_dialog.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/assets_manager.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';
import '../dialogs/change_name_birthday_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return BaseView<ProfileViewModel>(onModelReady: (viewModel) {
      viewModel.getUserData();
    }, builder: (context, viewModel, child) {
      return Scaffold(
          appBar: const CustomAppBar(
            title: 'حسابي الشخصي',
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
                      Stack(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 2),
                              image: DecorationImage(
                                image: viewModel.image != null
                                    ? FileImage(viewModel.image!)
                                    : const AssetImage(
                                            AssetsManager.userProfile)
                                        as ImageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            left: 30,
                            child: IconButton(
                                onPressed: () {
                                  viewModel.changeProfileImage();
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Theme.of(context).iconTheme.color,
                                )),
                          )
                        ],
                      ),
                      horizontalSpace(10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TitleTextWidget(
                                    label: "مرحباً يا ${viewModel.userName} 🦋",
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ChangeNameAndBirthdayDialog(
                                          userName: viewModel.userName,
                                          userBirthday: viewModel.userBirthday,
                                        );
                                      },
                                    );
                                    if (result != null) {
                                      if (result["birthday"] != null) {
                                        viewModel.changeUserBirthday(result["birthday"]);
                                      }
                                      if (result["name"] != null) {
                                        viewModel.changeUserName(result["name"]);
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).iconTheme.color,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                            const SubtitleTextWidget(
                                label: "اتمنى ان تكون بخير 💙"),
                            verticalSpace(8),
                            if (viewModel.userBirthday != null)
                              Row(
                                children: [
                                  Icon(Icons.cake,
                                      size: 18,
                                      color: Theme.of(context).cardColor),
                                  horizontalSpace(4),
                                  ContentTextWidget(
                                    label:
                                        "تاريخ ميلادك: ${viewModel.formattedBirthday}",
                                    fontSize: 14,
                                  )
                                ],
                              )
                            else
                              GestureDetector(
                                onTap: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ChangeNameAndBirthdayDialog(
                                        userName: viewModel.userName,
                                        userBirthday: viewModel.userBirthday,
                                      );
                                    },
                                  );
                                  if (result != null) {
                                    if (result["birthday"] != null) {
                                      viewModel.changeUserBirthday(result["birthday"]);
                                    }
                                    if (result["name"] != null) {
                                      viewModel.changeUserName(result["name"]);
                                    }
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.cake_outlined,
                                        size: 18,
                                        color: Theme.of(context).cardColor),
                                    horizontalSpace(4),
                                    const ContentTextWidget(
                                      label: "اختر تاريخ ميلادك",
                                      fontSize: 14,
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
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
                      verticalSpace(7),
                      const SubtitleTextWidget(label: "إعدادات التطبيق"),
                      verticalSpace(7),
                      SwitchListTile(
                        secondary: Image.asset(
                          AssetsManager.darkMode,
                          height: 40,
                        ),
                        title: ContentTextWidget(
                          label: themeProvider.getIsDarkTheme
                              ? "الوضع الليلي"
                              : "الوضع النهاري",
                        ),
                        value: themeProvider.getIsDarkTheme,
                        onChanged: (value) {
                          themeProvider.setDarkTheme(themeValue: value);
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      SwitchListTile(
                        secondary: Image.asset(
                          AssetsManager.notificationJar,
                        ),
                        title: const ContentTextWidget(
                          label: 'إشعارات التطبيق',
                        ),
                        value: viewModel.isNotificationOn,
                        onChanged: (value) {
                          viewModel.enableNotification(value);
                          value
                              ? showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    backgroundColor:
                                        Theme.of(context).iconTheme.color!,
                                    message: "تم تفعيل الإشعارات",
                                    icon: Icon(
                                      Icons.notifications_active,
                                      color: Theme.of(context).cardColor,
                                      size: 50,
                                    ),
                                  ),
                                )
                              : showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    backgroundColor:
                                        Theme.of(context).cardColor,
                                    message: "تم إيقاف الإشعارات",
                                    icon: Icon(
                                      Icons.notifications_off,
                                      color: Theme.of(context).iconTheme.color,
                                      size: 50,
                                    ),
                                  ),
                                );
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      if (viewModel.version != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListTile(
                            title: const ContentTextWidget(
                              label: 'إصدار التطبيق',
                            ),
                            leading: Icon(
                              Icons.verified,
                              color: Theme.of(context).iconTheme.color,
                              size: 30,
                            ),
                            trailing: ContentTextWidget(
                              label: viewModel.version,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => const InfoDialog(
                                        content: AppConstants.appVersionMessage,
                                      ));
                            },
                          ),
                        ),
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      verticalSpace(7),
                      const SubtitleTextWidget(label: "المزيد .."),
                      verticalSpace(7),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'صفحتنا على الفيسبوك',
                        ),
                        leading: const Icon(Icons.facebook),
                        onTap: () {
                          viewModel.openFacebookPage();
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'عن التطبيق',
                        ),
                        leading: const Icon(Icons.info),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => const InfoDialog(
                                    content: AppConstants.appInfo,
                                  ));
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'تقييم التطبيق',
                        ),
                        leading: const Icon(Icons.star),
                        onTap: () {
                          viewModel.rateApp();
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'مشاركة التطبيق',
                        ),
                        leading: const Icon(Icons.share),
                        onTap: () {
                          final RenderBox? box =
                              context.findRenderObject() as RenderBox?;
                          viewModel.shareApp(box);
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'تقديم اقتراح / اتصل بنا',
                        ),
                        leading: const Icon(Icons.rate_review),
                        onTap: () {
                          viewModel.contact();
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'للتواصل مع المطور',
                        ),
                        leading: const Icon(Icons.developer_mode),
                        onTap: () {
                          viewModel.contactWithDeveloper();
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'كود التطبيق على GitHub',
                        ),
                        leading: const Icon(Icons.code),
                        onTap: () {
                          viewModel.openGithub();
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'المزيد من التطبيقات المجانية',
                        ),
                        leading: const Icon(Icons.apps),
                        onTap: () {
                          viewModel.moreApps();
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: const ContentTextWidget(
                          label: 'سياسة الخصوصية',
                        ),
                        leading: const Icon(Icons.privacy_tip),
                        onTap: () {
                          viewModel.openPrivacyPolicy();
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: SubtitleTextWidget(
                          label: 'حذف الحساب',
                          color: Theme.of(context).cardColor,
                        ),
                        leading: Icon(
                          Icons.delete_forever,
                          color: Theme.of(context).cardColor,
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => WarningDialog(
                                    content: AppConstants.deleteAccountMessage,
                                    onConfirm: () {
                                      locator<NavigationService>().goBack();
                                      viewModel.deleteAccount();
                                    },
                                  ));
                        },
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: SubtitleTextWidget(
                          label: 'تسجيل الخروج',
                          color: Theme.of(context).cardColor,
                        ),
                        leading: Icon(
                          Icons.logout,
                          color: Theme.of(context).cardColor,
                        ),
                        onTap: () {
                          viewModel.logOut();
                        },
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
