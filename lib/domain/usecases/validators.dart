String? validateEmail(String value) {
  final email = value.trim();
  if (email.isEmpty) {
    return 'Введите email';
  }

  final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!regex.hasMatch(email)) {
    return 'Некорректный email';
  }

  return null;
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return 'Введите пароль';
  }
  if (value.length < 6) {
    return 'Пароль должен быть не короче 6 символов';
  }
  return null;
}
