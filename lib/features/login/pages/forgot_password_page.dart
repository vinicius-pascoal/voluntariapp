import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voluntariapp/features/login/pages/login_page.dart';
import 'package:voluntariapp/features/login/widgets/login_layout.dart';
import 'package:voluntariapp/features/login/widgets/login_text_field.dart';
import 'package:voluntariapp/features/login/widgets/recovery_button.dart';
import 'package:voluntariapp/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  String? mensagem;
  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> recuperarSenha() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() => mensagem = 'Informe o e-mail cadastrado.');
      return;
    }

    setState(() {
      carregando = true;
      mensagem = null;
    });

    try {
      await AuthService().sendPasswordResetEmail(email);
      setState(() {
        mensagem = 'Enviamos um link de recuperação para o e-mail informado.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            mensagem = 'E-mail inválido.';
            break;
          case 'user-not-found':
            mensagem = 'Nenhuma conta encontrada com esse e-mail.';
            break;
          default:
            mensagem = 'Não foi possível enviar o e-mail de recuperação.';
        }
      });
    } catch (_) {
      setState(() => mensagem = 'Erro inesperado ao recuperar senha.');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

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
            LoginTextField(
              controller: emailController,
              label: 'Informe seu e-mail:',
              hint: 'Digite seu e-mail',
            ),
            const SizedBox(height: 16),
            const Text(
              'Você receberá um link do Firebase para cadastrar uma nova senha com segurança.',
              style: TextStyle(color: Colors.black54),
            ),
            if (mensagem != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  mensagem!,
                  style: TextStyle(
                    color: mensagem!.startsWith('Enviamos')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            carregando
                ? const Center(child: CircularProgressIndicator())
                : RecoveryButton(text: 'Recuperar', onPressed: recuperarSenha),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (_) => false,
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
