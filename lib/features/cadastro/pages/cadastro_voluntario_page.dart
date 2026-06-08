import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voluntariapp/features/home/pages/home.dart';
import 'package:voluntariapp/services/auth_service.dart';

class CadastroVoluntarioPage extends StatefulWidget {
  const CadastroVoluntarioPage({super.key});

  @override
  State<CadastroVoluntarioPage> createState() => _CadastroVoluntarioPageState();
}

class _CadastroVoluntarioPageState extends State<CadastroVoluntarioPage> {
  final nomeController = TextEditingController();
  final sobrenomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool obscurePassword = true;
  bool carregando = false;
  String? mensagemErro;

  @override
  void dispose() {
    nomeController.dispose();
    sobrenomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> cadastrar() async {
    final nome = nomeController.text.trim();
    final sobrenome = sobrenomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if ([nome, sobrenome, email, senha].any((value) => value.isEmpty)) {
      setState(() => mensagemErro = 'Preencha todos os campos obrigatórios.');
      return;
    }

    if (senha.length < 6) {
      setState(() => mensagemErro = 'A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    setState(() {
      carregando = true;
      mensagemErro = null;
    });

    try {
      await AuthService().registerVolunteer(
        name: nome,
        surname: sobrenome,
        email: email,
        password: senha,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => mensagemErro = _firebaseMessage(e.code));
    } catch (_) {
      setState(() => mensagemErro = 'Erro inesperado ao cadastrar usuário.');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  Future<void> loginGoogle() async {
    setState(() {
      carregando = true;
      mensagemErro = null;
    });

    try {
      final credential = await AuthService().signInWithGoogle(defaultType: 'voluntario');
      if (!mounted) return;
      if (credential == null) {
        setState(() => mensagemErro = 'Login com Google cancelado.');
        return;
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (_) => false,
      );
    } catch (_) {
      setState(() => mensagemErro = 'Não foi possível entrar com Google.');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  String _firebaseMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'weak-password':
        return 'Senha muito fraca.';
      default:
        return 'Não foi possível realizar o cadastro.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SizedBox(width: 340, height: 82, child: Image.asset('assets/logo.png', fit: BoxFit.contain)),
                const SizedBox(height: 49),
                SizedBox(
                  width: 320,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x738eb6ff),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _RequiredLabel('Nome'),
                          const SizedBox(height: 8),
                          _CadastroTextField(controller: nomeController),
                          const SizedBox(height: 24),
                          const _RequiredLabel('Sobrenome'),
                          const SizedBox(height: 8),
                          _CadastroTextField(controller: sobrenomeController),
                          const SizedBox(height: 24),
                          const _RequiredLabel('Email'),
                          const SizedBox(height: 8),
                          _CadastroTextField(controller: emailController, keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 24),
                          const _RequiredLabel('Senha'),
                          const SizedBox(height: 8),
                          _CadastroTextField(
                            controller: senhaController,
                            obscureText: obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () => setState(() => obscurePassword = !obscurePassword),
                            ),
                          ),
                          if (mensagemErro != null) ...[
                            const SizedBox(height: 12),
                            Text(mensagemErro!, style: const TextStyle(color: Colors.red)),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA500),
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: carregando ? null : cadastrar,
                              child: carregando
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('Cadastrar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 33),
                Center(
                  child: InkWell(
                    onTap: carregando ? null : loginGoogle,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/letra.png', width: 38, height: 34, fit: BoxFit.contain),
                          const SizedBox(width: 8),
                          const Text('Login com Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$text ',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          height: 1.4,
        ),
        children: const [
          TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _CadastroTextField extends StatelessWidget {
  const _CadastroTextField({
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
