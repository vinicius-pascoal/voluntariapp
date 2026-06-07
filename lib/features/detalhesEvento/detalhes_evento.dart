import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/widgets/arca_informationis.dart';
import 'package:voluntariapp/features/perfil/widgets/bullam_retro.dart';
import 'package:voluntariapp/models/event.dart';
import 'package:voluntariapp/services/participation_service.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class DetalhesEvento extends StatelessWidget {
  final Event event;

  const DetalhesEvento({
    super.key,
    required this.event,
  });

  // TODO: mudar quando implementar estado.
  final String teste = "Escreva aqui.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: 240,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 40, height: 40, child: const BullamRetro()),
                    ],
                  ),
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    event.organization,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ArcaInformationis(
                    label: "Descrição",
                    child: Text(
                      event.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ArcaInformationis(
                    label: 'Data',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                         '${event.date.day}/${event.date.month}/${event.date.year}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          '07:00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ArcaInformationis(
                    label: 'Local',
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          "https://stories.cnnbrasil.com.br/wp-content/uploads/sites/9/2024/12/mapa-ibge-aracaju-sao-cristovao.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      await ParticipationService().participate(event);
                    },
                    child: const Text("Confirmar Presença"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
