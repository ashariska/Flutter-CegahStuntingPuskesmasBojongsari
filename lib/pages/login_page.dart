import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stunting_web/pages/home_page.dart';
import 'package:stunting_web/styles/style.dart';
import 'package:stunting_web/widgets/login_card2.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _saveLoginStatus(String role) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    final expirationTime = now + 3600000;

    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('expirationTime', expirationTime);
    await prefs.setString('role', role);
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final expirationTime = prefs.getInt('expirationTime') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (isLoggedIn && expirationTime > now) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 1), () {
        if ((_usernameController.text == 'admin' &&
                _passwordController.text == '12345678') ||
            (_usernameController.text == 'user' &&
                _passwordController.text == '12345678')) {
          _saveLoginStatus(_usernameController.text); // Simpan status login
          ScaffoldMessenger.of(context);
          General.showSnackBar(context, 'Berhasil Login');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context);
          General.showSnackBar(context, 'Username atau password salah');
        }
        setState(() => _isLoading = false);
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginCard2(
        formKey: _formKey,
        usernameController: _usernameController,
        passwordController: _passwordController,
        isPasswordVisible: _isPasswordVisible,
        isLoading: _isLoading,
        onTogglePassword: () {
          setState(() => _isPasswordVisible = !_isPasswordVisible);
        },
        onLogin: _login,
      ),
    );
  }
}
