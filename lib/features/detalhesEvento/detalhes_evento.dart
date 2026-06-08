import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/widgets/arca_informationis.dart';
import 'package:voluntariapp/features/perfil/widgets/bullam_retro.dart';
import 'package:voluntariapp/models/event.dart';
import 'package:voluntariapp/services/participation_service.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class DetalhesEvento extends StatelessWidget {
  final Event event;

  const DetalhesEvento({super.key, required this.event});

  Future<void> _toggleParticipation(BuildContext context, bool isParticipating) async {
    try {
      if (isParticipating) {
        await ParticipationService().cancelParticipation(event.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presença cancelada com sucesso.')),
        );
      } else {
        final created = await ParticipationService().participate(event);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(created
                ? 'Presença confirmada com sucesso.'
                : 'Você já confirmou presença nesse evento.'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar presença: $e')),
      );
    }
  }

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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    children: [SizedBox(width: 40, height: 40, child: BullamRetro())],
                  ),
                  Text(
                    event.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(event.organization, style: const TextStyle(fontSize: 14)),
                  if (event.category.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Chip(label: Text(event.category)),
                  ],
                  const SizedBox(height: 24),
                  if (event.imageUrl.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          event.imageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ArcaInformationis(
                    label: 'Descrição',
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
                          _formatDate(event.date),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          _formatTime(event.date),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ArcaInformationis(
                    label: 'Local',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                event.location.isEmpty ? 'Local não informado' : event.location,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/map.png',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 180,
                              color: Colors.white,
                              child: const Center(child: Icon(Icons.map_outlined, size: 72)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (event.availableSlots > 0) ...[
                    const SizedBox(height: 16),
                    ArcaInformationis(
                      label: 'Vagas',
                      child: Text('${event.availableSlots} vagas disponíveis'),
                    ),
                  ],
                  const SizedBox(height: 25),
                  StreamBuilder<bool>(
                    stream: ParticipationService().isParticipating(event.id),
                    builder: (context, snapshot) {
                      final isParticipating = snapshot.data ?? false;
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isParticipating ? Colors.redAccent : const Color(0xFFFFA500),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _toggleParticipation(context, isParticipating),
                        icon: Icon(isParticipating ? Icons.close : Icons.check),
                        label: Text(isParticipating ? 'Cancelar Presença' : 'Confirmar Presença'),
                      );
                    },
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
