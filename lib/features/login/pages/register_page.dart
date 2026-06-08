import 'package:flutter/material.dart';
import 'package:voluntariapp/features/cadastro/pages/tipo_perfil_page.dart';
import 'package:voluntariapp/features/login/pages/login_page.dart';
import 'package:voluntariapp/features/login/widgets/login_layout.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginLayout(
      showBackButtom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Escolha o tipo de conta que deseja cadastrar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TipoPerfilPage()),
                );
              },
              child: const Text('Ir para cadastro'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (_) => false,
                );
              },
              child: const Text('Já tenho conta'),
            ),
          ],
        ),
      ),
    );
  }
}
