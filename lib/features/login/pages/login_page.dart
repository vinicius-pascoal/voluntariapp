import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
    final senha = senhaController.text;

    if (email.isEmpty || senha.trim().isEmpty) {
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
      _abrirHome();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('FirebaseAuthException no login: ${e.code} - ${e.message}');
      }
      if (!mounted) return;
      setState(() => mensagemErro = _mensagemErroFirebase(e.code));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erro inesperado no login: $e');
      }
      if (!mounted) return;
      setState(() => mensagemErro = 'Erro inesperado ao fazer login.');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  Future<void> entrarComGoogle() async {
    setState(() {
      carregando = true;
      mensagemErro = null;
    });

    try {
      final credential = await AuthService().signInWithGoogle(
        defaultType: 'voluntario',
      );

      if (!mounted) return;

      if (credential == null) {
        setState(() => mensagemErro = 'Login com Google cancelado.');
        return;
      }

      _abrirHome();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('FirebaseAuthException no Google: ${e.code} - ${e.message}');
      }
      if (!mounted) return;
      setState(() => mensagemErro = _mensagemErroFirebase(e.code));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erro inesperado no Google: $e');
      }
      if (!mounted) return;
      setState(
        () => mensagemErro =
            'Não foi possível entrar com Google. Verifique a configuração do provedor no Firebase.',
      );
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  void _abrirHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Home()),
      (_) => false,
    );
  }

  String _mensagemErroFirebase(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'E-mail ou senha incorretos. Se essa conta foi criada pelo Google, entre pelo botão "Login com Google".';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas de login. Aguarde um pouco e tente novamente.';
      case 'network-request-failed':
        return 'Falha de conexão. Verifique sua internet e tente novamente.';
      case 'operation-not-allowed':
        return 'Login com e-mail e senha não está habilitado no Firebase Authentication.';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com esse e-mail usando outro método de login.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Login com Google cancelado.';
      default:
        return 'Erro ao fazer login. Código: $code';
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: carregando ? null : entrarComGoogle,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: const BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Image.asset(
                  'assets/letra.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                label: const Text(
                  'Login com Google',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: carregando
                    ? null
                    : () {
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
                onPressed: carregando
                    ? null
                    : () {
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
