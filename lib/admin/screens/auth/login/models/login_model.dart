class LoginCredentials {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginCredentials({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
  });

  LoginCredentials copyWith({
    String? email,
    String? password,
    bool? rememberMe,
  }) {
    return LoginCredentials(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  bool get isEmailEmpty => email.trim().isEmpty;
  bool get isPasswordEmpty => password.trim().isEmpty;
}
