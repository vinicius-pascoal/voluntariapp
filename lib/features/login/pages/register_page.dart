import 'package:flutter/material.dart';
import 'package:voluntariapp/features/login/widgets/login_layout.dart';

import '../widgets/forgot_password.dart';
import '../widgets/recovery_button.dart';

class RegisterPage extends StatelessWidget{
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ForgotPasswordTextField(label: 'Insira seu E-mail:', hint: 'Insira o seu E-mail aqui.'),
            SizedBox(height: 18),
            ForgotPasswordTextField(
              label: 'Insira o código:',
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
                onPressed: () {},
                child: const Text('Não possui uma conta? Cadastre-se.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}