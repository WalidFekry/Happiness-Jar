import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/validators.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/subtitle_text.dart';

class ChangeNameAndBirthdayDialog extends StatefulWidget {
  final String? userName;
  final DateTime? userBirthday;

  const ChangeNameAndBirthdayDialog({
    Key? key,
    this.userName,
    this.userBirthday,
  }) : super(key: key);

  @override
  State<ChangeNameAndBirthdayDialog> createState() =>
      _ChangeNameAndBirthdayDialogState();
}

class _ChangeNameAndBirthdayDialogState
    extends State<ChangeNameAndBirthdayDialog> {
  late TextEditingController _nameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedBirthday;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName ?? '');
    _selectedBirthday = widget.userBirthday;
  }

  Future<void> _pickBirthday() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(1999, 8, 19),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedBirthday = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const SubtitleTextWidget(
          label: "تغيير بياناتك",
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetsManager.profileJar,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLength: 20,
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "ادخل الاسم الجديد",
                ),
                validator: Validators.validateUserName,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickBirthday,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cake, color: Theme.of(context).cardColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ContentTextWidget(label:
                          _selectedBirthday != null
                              ? "${_selectedBirthday!.day}-${_selectedBirthday!.month}-${_selectedBirthday!.year}"
                              : "اختر تاريخ ميلادك",
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              locator<NavigationService>().goBackWithData(null);
            },
            child: ContentTextWidget(
              label: "إلغاء",
              color: Theme.of(context).primaryColor,
            ),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                locator<NavigationService>().goBackWithData({
                  "name": _nameController.text.trim(),
                  "birthday": _selectedBirthday,
                });
              }
            },
            child: ContentTextWidget(
              label: "حفظ",
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
