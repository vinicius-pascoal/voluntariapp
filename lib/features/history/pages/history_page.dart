import 'package:flutter/material.dart';
import 'package:voluntariapp/features/history/widgets/history_app_bar.dart';
import 'package:voluntariapp/features/history/widgets/history_card.dart';
import 'package:voluntariapp/features/history/widgets/history_search.dart';
import 'package:voluntariapp/models/participation.dart';
import 'package:voluntariapp/services/participation_service.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  final searchController = TextEditingController();
  String searchTerm = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Participation> _filter(List<Participation> participations) {
    final term = searchTerm.trim().toLowerCase();
    if (term.isEmpty) return participations;
    return participations.where((item) {
      return item.eventTitle.toLowerCase().contains(term) ||
          item.organization.toLowerCase().contains(term) ||
          item.location.toLowerCase().contains(term);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      appBar: const HistoryAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: HistorySearch(
              controller: searchController,
              onChanged: (value) => setState(() => searchTerm = value),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Participation>>(
              stream: ParticipationService().getUserParticipations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final participations = _filter(snapshot.data ?? []);

                if (participations.isEmpty) {
                  return const Center(
                    child: Text(
                      'Você ainda não participou de nenhum evento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: participations.length,
                  itemBuilder: (context, index) {
                    final participation = participations[index];
                    return HistoryCard(participation: participation);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
