import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/widgets/bullam_retro.dart';
import 'package:voluntariapp/features/perfil/widgets/dies_nativitates.dart';
import 'package:voluntariapp/features/perfil/widgets/imago_profili.dart';
import 'package:voluntariapp/features/perfil/widgets/navigationis.dart';
import 'package:voluntariapp/features/perfil/widgets/scripturam_arca.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  //TODO: mudar quando implementar estado.
  final String teste = "Escreva aqui.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 550,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 40, height: 40, child: BullamRetro()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const ImagoProfili(),
                      const SizedBox(height: 32),
                      const ScripturamArca(label: "Nome", content: "Ocupação"),
                      const SizedBox(height: 20),
                      const DiesNativitates(),
                      const SizedBox(height: 32),
                      ScripturamArca(label: "Sobre Mim", content: teste),
                      const SizedBox(height: 32),
                      ScripturamArca(label: "Experiências", content: teste),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
