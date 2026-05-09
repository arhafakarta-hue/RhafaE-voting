class ValidationUtils {
  static bool isValidNim(String nim) {
    return nim.isNotEmpty && nim.length >= 3;
  }

  static bool isValidPassword(String password) {
    return password.isNotEmpty && password.length >= 3;
  }

  static bool isValidName(String name) {
    return name.isNotEmpty && name.length >= 2;
  }

  static String? validateNim(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIS/NIM tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'NIS/NIM minimal 3 karakter';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Password minimal 3 karakter';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }
}
