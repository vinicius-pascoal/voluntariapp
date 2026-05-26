import 'package:flutter/material.dart';
import 'package:voluntariapp/features/login/pages/register_page.dart';
import 'package:voluntariapp/features/login/widgets/login_button.dart';
import 'package:voluntariapp/features/login/widgets/login_layout.dart';
import 'package:voluntariapp/features/login/widgets/login_text_field.dart';
import 'package:voluntariapp/features/login/pages/forgot_password_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginTextField(label: 'Login', hint: 'E-mail'),
            SizedBox(height: 18),
            LoginTextField(
              label: 'Senha',
              hint: '*********',
              obscureText: true,
              suffixIcon: Icon(Icons.visibility_outlined),
            ),
            SizedBox(height: 40),
            LoginButton(text: 'Login', onPressed: () {}),
            SizedBox(height: 100),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Text('Esqueci minha senha.'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text('Não possui uma conta? Cadastre-se.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
