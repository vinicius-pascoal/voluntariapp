import 'package:flutter/material.dart';
import 'package:voluntariapp/features/cadastro/pages/tipo_perfil_page.dart';
import 'package:voluntariapp/features/login/widgets/login_layout.dart';
import 'package:voluntariapp/features/login/widgets/login_text_field.dart';
import 'package:voluntariapp/features/login/pages/login_page.dart';

import '../widgets/forgot_password.dart';
import '../widgets/recovery_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginLayout(
      showBackButtom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LoginTextField(
              label: 'Informe seu E-mail:',
              hint: 'Digite seu E-mail',
            ),
            const SizedBox(height: 20),
            ForgotPasswordTextField(
              label: 'Crie uma nova senha:',
              hint: '************',
            ),
            const SizedBox(height: 20),
            ForgotPasswordTextField(
              label: 'Confirme sua senha:',
              hint: '************',
              obscureText: true,
              suffixIcon: Icon(Icons.visibility_outlined),
            ),
            const SizedBox(height: 20),
            RecoveryButton(
                text: 'Recuperar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text('Voltar ao Login.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
