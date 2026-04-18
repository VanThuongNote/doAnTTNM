import 'package:flutter/material.dart';

class UserAccount {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? birthDate;

  UserAccount({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.birthDate,
  });
}

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final List<UserAccount> _accounts = [];
  UserAccount? _currentUser;

  UserAccount? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Register a new account
  String? register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? birthDate,
  }) {
    if (email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      return 'Vui lòng điền đầy đủ thông tin';
    }
    if (password.length < 4) {
      return 'Mật khẩu phải có ít nhất 4 ký tự';
    }
    if (_accounts.any((a) => a.email.toLowerCase() == email.toLowerCase())) {
      return 'Email đã được đăng ký';
    }
    _accounts.add(UserAccount(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      birthDate: birthDate,
    ));
    notifyListeners();
    return null; // success
  }

  // Login
  String? login(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'Vui lòng nhập email và mật khẩu';
    }
    final account = _accounts.where(
      (a) => a.email.toLowerCase() == email.toLowerCase() && a.password == password,
    ).firstOrNull;

    if (account == null) {
      return 'Tên đăng nhập hoặc mật khẩu sai';
    }
    _currentUser = account;
    notifyListeners();
    return null; // success
  }

  // Social login (simulated)
  void socialLogin(String provider) {
    _currentUser = UserAccount(
      email: '${provider.toLowerCase()}user@gmail.com',
      password: '',
      firstName: provider,
      lastName: 'User',
    );
    notifyListeners();
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
