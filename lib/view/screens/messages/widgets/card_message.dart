import 'package:flutter/material.dart';
import 'package:happiness_jar/consts/app_colors.dart';
import 'package:happiness_jar/consts/assets_manager.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          // margin: const EdgeInsets.only(top: 50), // Space for color options
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              image: _showImage
                  ? DecorationImage(
                image: widget.imageUrl == null
                    ? const AssetImage(AssetsManager.emptyJar,
                )
                as ImageProvider<Object>
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
        Positioned(
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
        Positioned(
          bottom: 0,
          right: 3,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.text_decrease,color: _selectedColor == Colors.transparent ? Theme.of(context).iconTheme.color : _selectedColor,size:20,),
                onPressed: () {
                  setState(() {
                    if (_fontSize > 10) _fontSize -= 2;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.text_increase,color: _selectedColor == Colors.transparent ? Theme.of(context).iconTheme.color : _selectedColor,size:20),
                onPressed: () {
                  setState(() {
                    _fontSize += 2;
                  });
                },
              ),
            ],
          ),
        ),
      ],
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
}
