String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Введите email';
  final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
  if (!regex.hasMatch(value)) return 'Введите корректный email';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Введите пароль';

  final rules = <String>[];

  if (value.length < 8) rules.add('Минимум 8 символов');
  if (!RegExp(r'[A-Z]').hasMatch(value)) rules.add('Заглавная буква');
  if (!RegExp(r'[a-z]').hasMatch(value)) rules.add('Строчная буква');
  if (!RegExp(r'\d').hasMatch(value)) rules.add('Цифра');
  if (!RegExp(r'[!@#\$%^&*()]').hasMatch(value)) rules.add('Спецсимвол');

  return rules.isEmpty ? null : rules.join('\n');
}

String? validatePasswordRepeat(
  String? value,
  String original,
) {
  if (value == null || value.isEmpty) return 'Повторите пароль';
  if (value != original) return 'Пароли не совпадают';
  return null;
}

String? validateNotEmpty(String? value, String fieldName) {
  if (value == null || value.isEmpty) return 'Введите $fieldName';
  return null;
}

String? validateConfirmPassword(String? value, String original) {
  if (value == null || value.isEmpty) {
    return 'Повторите пароль';
  }

  if (value != original) {
    return 'Пароли не совпадают';
  }
  return null;
}