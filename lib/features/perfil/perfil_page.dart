import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/widgets/bullam_retro.dart';
import 'package:voluntariapp/models/app_user.dart';
import 'package:voluntariapp/services/user_service.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final sobrenomeController = TextEditingController();
  final ocupacaoController = TextEditingController();
  final sobreController = TextEditingController();
  final experienciasController = TextEditingController();
  final fotoController = TextEditingController();
  final cnpjController = TextEditingController();

  DateTime? nascimento;
  bool initialized = false;
  bool saving = false;

  @override
  void dispose() {
    nomeController.dispose();
    sobrenomeController.dispose();
    ocupacaoController.dispose();
    sobreController.dispose();
    experienciasController.dispose();
    fotoController.dispose();
    cnpjController.dispose();
    super.dispose();
  }

  void _fillControllers(AppUser user) {
    if (initialized) return;
    initialized = true;
    nomeController.text = user.name;
    sobrenomeController.text = user.surname;
    ocupacaoController.text = user.occupation;
    sobreController.text = user.about;
    experienciasController.text = user.experiences;
    fotoController.text = user.photoUrl;
    cnpjController.text = user.cnpj;
    nascimento = user.birthDate;
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: nascimento ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => nascimento = picked);
  }

  Future<void> _save(AppUser user) async {
    if (!formKey.currentState!.validate()) return;

    setState(() => saving = true);
    try {
      await UserService().updateCurrentUser(
        name: nomeController.text,
        surname: sobrenomeController.text,
        occupation: ocupacaoController.text,
        birthDate: nascimento,
        about: sobreController.text,
        experiences: experienciasController.text,
        photoUrl: fotoController.text,
        cnpj: user.isOng ? cnpjController.text : null,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar perfil: $e')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        child: StreamBuilder<AppUser?>(
          stream: UserService().currentUserStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final user = snapshot.data;
            if (user == null) {
              return const Center(child: Text('Usuário não autenticado.'));
            }

            _fillControllers(user);

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 550, minHeight: constraints.maxHeight),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(children: [SizedBox(width: 40, height: 40, child: BullamRetro())]),
                            const SizedBox(height: 24),
                            _ProfileImage(photoUrl: fotoController.text),
                            const SizedBox(height: 16),
                            Text(user.isOng ? 'Perfil de Organização' : 'Perfil de Voluntário', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 24),
                            _ProfileField(label: 'Nome', controller: nomeController),
                            if (!user.isOng) ...[
                              const SizedBox(height: 16),
                              _ProfileField(label: 'Sobrenome', controller: sobrenomeController),
                            ],
                            if (user.isOng) ...[
                              const SizedBox(height: 16),
                              _ProfileField(label: 'CNPJ', controller: cnpjController, keyboardType: TextInputType.number),
                            ],
                            const SizedBox(height: 16),
                            _ProfileField(label: 'Ocupação', controller: ocupacaoController, requiredField: false),
                            const SizedBox(height: 16),
                            _BirthDatePicker(date: nascimento, onTap: _pickBirthDate),
                            const SizedBox(height: 16),
                            _ProfileField(label: 'URL da foto de perfil', controller: fotoController, requiredField: false, onChanged: (_) => setState(() {})),
                            const SizedBox(height: 16),
                            _ProfileField(label: user.isOng ? 'Sobre a organização' : 'Sobre Mim', controller: sobreController, requiredField: false, maxLines: 4),
                            const SizedBox(height: 16),
                            _ProfileField(label: user.isOng ? 'Áreas de atuação' : 'Experiências', controller: experienciasController, requiredField: false, maxLines: 4),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA500), foregroundColor: Colors.white),
                                onPressed: saving ? null : () => _save(user),
                                icon: saving
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Icon(Icons.save),
                                label: Text(saving ? 'Salvando...' : 'Salvar Perfil'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange, width: 3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: photoUrl.trim().isNotEmpty
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.account_box, size: 60, color: Colors.orange),
              )
            : const Icon(Icons.account_box, size: 60, color: Colors.orange),
      ),
    );
  }
}

class _BirthDatePicker extends StatelessWidget {
  const _BirthDatePicker({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Data de Nascimento / Fundação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD9D9D9)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.orange),
                const SizedBox(width: 12),
                Text(date == null ? 'Selecionar data' : '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.requiredField = true,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool requiredField;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 4))],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
              ),
            ),
            validator: (value) {
              if (requiredField && (value == null || value.trim().isEmpty)) {
                return 'Campo obrigatório';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
