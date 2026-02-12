class AuthValidationService {
  String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value!) ? null : 'Please enter a valid email';
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter your password';
    return (value!.length < 6)
        ? 'Password must be at least 6 characters'
        : null;
  }

  String? validateName(String? value) {
    return (value?.isEmpty ?? true) ? 'Please enter your name' : null;
  }

  String? validatePhone(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter your phone number';
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(value!)
        ? null
        : 'Please enter a valid phone number';
  }
}
