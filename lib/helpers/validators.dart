class Validators {
  static String? validateUserName(String? value) {
    // Check if the field is empty or contains only spaces
    if (value == null || value.trim().isEmpty) {
      return 'من فضلك قم بكتابة إسمك ⚠️';
    }
    // Check minimum length is 3 characters
    if (value.length < 3) {
      return 'اسم المستخدم يجب ان يكون على الاقل 3 حروف ⚠️';
    }
    // Check if the input is an email address
    if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'لا يمكن استخدام بريد إلكتروني كاسم مستخدم ⚠️';
    }
    // Check if the input contains at least one letter from any language
    if (!RegExp(r'[\p{L}]', unicode: true).hasMatch(value)) {
      return 'يجب أن يحتوي الاسم على حرف واحد على الأقل ⚠️';
    }
    // Allow letters from any language, spaces, dots (not at the start or end), emojis, and Arabic diacritics
    if (!RegExp(r'^(?!\.)(?!.*\.$)[\p{L}\s.\p{Emoji}\u064B-\u065F]+$', unicode: true).hasMatch(value)) {
      return 'يجب أن يحتوي الاسم على حروف أو إيموجي فقط بدون رموز خاصة ⚠️';
    }
    return null; // Valid input
  }

  static String? validateBirthDate(DateTime? date) {
    if (date == null) {
      return null;
    }

    final now = DateTime.now();

    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }

    if (age < 5) {
      return "العمر يجب أن يكون على الأقل 5 سنوات ⚠️";
    }
    if (age > 120) {
      return "العمر غير منطقي ⚠️";
    }

    return null;
  }
}
