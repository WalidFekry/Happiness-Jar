import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/constants/assets_manager.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CardMessageWidget extends StatefulWidget {
  const CardMessageWidget(
      {Key? key, required this.body, required this.imageUrl})
      : super(key: key);

  final String? imageUrl;
  final String? body;

  @override
  _CardMessageWidgetState createState() => _CardMessageWidgetState();
}

class _CardMessageWidgetState extends State<CardMessageWidget> {
  Color _selectedColor = Colors.transparent;
  bool _showImage = true;
  double _fontSize = 20.0;
  ScreenshotController screenshotController = ScreenshotController();
  bool takeScreenshot = false;

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            // margin: const EdgeInsets.only(top: 50), // Space for color options
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                image: _showImage
                    ? DecorationImage(
                        image: widget.imageUrl == null
                            ? const AssetImage(
                                AssetsManager.emptyJar,
                              ) as ImageProvider<Object>
                            : NetworkImage(widget.imageUrl!)
                                as ImageProvider<Object>,
                        fit: BoxFit.cover,
                        opacity: 0.5,
                        colorFilter: ColorFilter.mode(
                            _selectedColor, BlendMode.colorBurn),
                      )
                    : null,
                color: _selectedColor == Colors.transparent
                    ? Theme.of(context).scaffoldBackgroundColor
                    : _selectedColor,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: SubtitleTextWidget(
                  label: widget.body,
                  textAlign: TextAlign.center,
                  color: Colors.black,
                  fontSize: _fontSize,
                ),
              ),
            ),
          ),
          Visibility(
            visible: !takeScreenshot,
            child: Positioned(
              bottom: 5,
              left: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildColorOption(Theme.of(context).cardColor),
                  _buildColorOption(Theme.of(context).iconTheme.color!),
                  _buildColorOption(Theme.of(context).unselectedWidgetColor),
                  _buildColorOption(AppColors.lightScaffoldColor),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !takeScreenshot,
            child: Positioned(
              bottom: 0,
              right: 3,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.text_decrease,
                      color: _selectedColor == Colors.transparent
                          ? Theme.of(context).iconTheme.color
                          : _selectedColor,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_fontSize > 10) _fontSize -= 2;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.text_increase,
                        color: _selectedColor == Colors.transparent
                            ? Theme.of(context).iconTheme.color
                            : _selectedColor,
                        size: 20),
                    onPressed: () {
                      setState(() {
                        _fontSize += 2;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !takeScreenshot,
            child: Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                    onPressed: () {
                      saveToGallery();
                    },
                    icon: Icon(
                      Icons.download,
                      size: 25,
                      color: Theme.of(context).iconTheme.color,
                    ))),
          ),
          Visibility(
            visible: !takeScreenshot,
            child: Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () async {
                  sharePhoto();
                  },
                  icon: Icon(Icons.photo,
                      size: 25, color: Theme.of(context).iconTheme.color),
                )),
          ),
          Visibility(
            visible: takeScreenshot,
            child: Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(AssetsManager.appLogo,width: 90,height: 90,fit:  BoxFit.contain,)),
          )
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
          _showImage = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Future<void> saveToGallery() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    setState(() {
      takeScreenshot = true;
    });
      screenshotController
          .capture(delay: const Duration(seconds: 1))
          .then((image) async {
        if (image != null) {
          try {
            final result =
            await ImageGallerySaver.saveImage(image);
            if (result['isSuccess']) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.success(
                  backgroundColor: Theme.of(context).iconTheme.color!,
                  message:
                  "تم الحفظ كصورة بنجاح",
                  icon: Icon(Icons.download,color: Theme.of(context).cardColor,
                    size: 50,),
                ),
              );
            } else {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  backgroundColor: Theme.of(context).cardColor,
                  message:
                  "حدث خطأ أثناء حفظ الصورة",
                  icon: Icon(Icons.download,color: Theme.of(context).iconTheme.color,
                    size: 50,),
                ),
              );
            }
          } catch (e) {
            if (kDebugMode) {
              print('خطأ أثناء حفظ أو مشاركة الصورة: $e');
            }
          }
        }else{
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              backgroundColor: Theme.of(context).cardColor,
              message:
              "حدث خطأ أثناء حفظ الصورة",
              icon: Icon(Icons.download,color: Theme.of(context).iconTheme.color,
                size: 50,),
            ),
          );
        }
        setState(() {
          takeScreenshot = false;
        });
      });
  }

  Future<void> sharePhoto() async {
    setState(() {
      takeScreenshot = true;
    });
    await screenshotController
        .capture(delay: const Duration(seconds: 1))
        .then((image) async {
      if (image != null) {
        try {
          final directory =
          await getApplicationDocumentsDirectory();
          final imagePath =
          await File('${directory.path}/image.png').create();
          await imagePath.writeAsBytes(image);
          final xFile = XFile(imagePath.path);
          await Share.shareXFiles(
            [xFile],
            subject: 'من تطبيق برطمان السعادة 💙',
            text: widget.body,
          );
        } catch (e) {
          if (kDebugMode) {
            print('خطأ أثناء حفظ أو مشاركة الصورة: $e');
          }
        }
      }else{
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            backgroundColor: Theme.of(context).cardColor,
            message:
            "حدث خطأ أثناء مشاركة الصورة",
            icon: Icon(Icons.share,color: Theme.of(context).iconTheme.color,
              size: 50,),
          ),
        );
      }
      setState(() {
        takeScreenshot = false;
      });
    });
  }
}
