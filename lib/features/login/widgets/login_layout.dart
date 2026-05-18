import 'package:flutter/material.dart';

class LoginLayout extends StatelessWidget {
  final Widget child;

  const LoginLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 55),
              Image.asset('assets/images/logo.png'),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
