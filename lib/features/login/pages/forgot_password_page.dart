import 'package:flutter/material.dart';
import 'package:voluntariapp/features/login/pages/register_page.dart';
import 'package:voluntariapp/features/login/widgets/login_layout.dart';

import '../widgets/forgot_password.dart';
import '../widgets/recovery_button.dart';

class ForgotPasswordPage extends StatelessWidget{
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginLayout(
      showBackButtom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ForgotPasswordTextField(label: 'Crie uma nova senha:', hint: 'Crie a nova senha:'),
            SizedBox(height: 18),
            ForgotPasswordTextField(
              label: 'Confirme sua senha:',
              hint: '*********',
              obscureText: true,
              suffixIcon: Icon(Icons.visibility_outlined),
            ),
            SizedBox(height: 18),
            RecoveryButton(text: 'Recuperar', onPressed: (){}),
            SizedBox(height: 100),
            Center(
              child: TextButton(
                onPressed: () {},
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