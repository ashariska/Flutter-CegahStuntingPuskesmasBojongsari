import 'package:flutter/material.dart';
import 'package:stunting_web/constants/colors.dart';
import 'package:stunting_web/constants/gradients.dart';
import 'package:stunting_web/widgets/animated_text_carousel.dart';

class LoginCard2 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  const LoginCard2({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onLogin,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: CustomGradient.scaffoldGradient,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png', width: 200, height: 200),
                      Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Data Stunting Puskesmas Bojongsari',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedTextCarousel(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Kanan (Login Form)
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: CustomColor.bluePrimary,
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Username
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.account_circle),
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Username' : null,
                      ),
                      const SizedBox(height: 30),

                      // Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: onTogglePassword,
                          ),
                          border: const UnderlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Masukkan Password'
                            : null,
                        onFieldSubmitted: (_) {
                          if (formKey.currentState!.validate()) {
                            onLogin();
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Button login
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColor.bgMain,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Overlay loading full screen
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
