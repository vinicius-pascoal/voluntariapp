import 'package:flutter/material.dart';
import 'package:voluntariapp/features/history/pages/history_page.dart';
import 'package:voluntariapp/features/cadastro/pages/tipo_perfil_page.dart';
import 'package:voluntariapp/features/login/pages/register_page.dart';
import 'package:voluntariapp/features/login/widgets/login_button.dart';
import 'package:voluntariapp/features/login/widgets/login_layout.dart';
import 'package:voluntariapp/features/login/widgets/login_text_field.dart';
import 'package:voluntariapp/features/login/pages/forgot_password_page.dart';
import 'package:voluntariapp/features/home/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  String? mensagemErro;

  Future<void> fazerLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      setState(() {
        mensagemErro = null;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            mensagemErro = 'Usuário não encontrado.';
            break;

          case 'wrong-password':
          case 'invalid-credential':
            mensagemErro = 'E-mail ou senha incorretos.';
            break;

          case 'invalid-email':
            mensagemErro = 'E-mail inválido.';
            break;

          case 'too-many-requests':
            mensagemErro = 'Muitas tentativas. Tente novamente mais tarde.';
            break;

          default:
            mensagemErro = 'Erro ao fazer login.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginTextField(controller: emailController,
                label: 'Login',
                hint: 'E-mail'),
            const SizedBox(height: 18),
            LoginTextField(controller: senhaController,
              label: 'Senha',
              hint: '*********',
              obscureText: true,
              suffixIcon: Icon(Icons.visibility_outlined),
            ),
            if (mensagemErro != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  mensagemErro!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(height: 18),
            LoginButton(
              text: 'Login',
              onPressed: fazerLogin,
            ),
            const SizedBox(height: 48),
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
                      builder: (context) => const TipoPerfilPage(),
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
