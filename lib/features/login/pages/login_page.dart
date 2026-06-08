import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voluntariapp/features/cadastro/pages/tipo_perfil_page.dart';
import 'package:voluntariapp/features/home/pages/home.dart';
import 'package:voluntariapp/features/login/pages/forgot_password_page.dart';
import 'package:voluntariapp/features/login/widgets/login_button.dart';
import 'package:voluntariapp/features/login/widgets/login_layout.dart';
import 'package:voluntariapp/features/login/widgets/login_text_field.dart';
import 'package:voluntariapp/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  String? mensagemErro;
  bool carregando = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> fazerLogin() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      setState(() => mensagemErro = 'Informe e-mail e senha para continuar.');
      return;
    }

    setState(() {
      carregando = true;
      mensagemErro = null;
    });

    try {
      await AuthService().login(email: email, password: senha);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-credential':
          case 'wrong-password':
          case 'user-not-found':
            mensagemErro = 'E-mail ou senha incorretos.';
            break;
          case 'invalid-email':
            mensagemErro = 'E-mail inválido.';
            break;
          case 'user-disabled':
            mensagemErro = 'Esta conta foi desativada.';
            break;
          default:
            mensagemErro = 'Erro ao fazer login. Tente novamente.';
        }
      });
    } catch (_) {
      setState(() => mensagemErro = 'Erro inesperado ao fazer login.');
    } finally {
      if (mounted) setState(() => carregando = false);
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
            LoginTextField(
              controller: emailController,
              label: 'Login',
              hint: 'E-mail',
            ),
            const SizedBox(height: 18),
            LoginTextField(
              controller: senhaController,
              label: 'Senha',
              hint: '*********',
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() => obscurePassword = !obscurePassword);
                },
              ),
            ),
            if (mensagemErro != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  mensagemErro!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const SizedBox(height: 18),
            carregando
                ? const Center(child: CircularProgressIndicator())
                : LoginButton(text: 'Login', onPressed: fazerLogin),
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
            const SizedBox(height: 20),
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
