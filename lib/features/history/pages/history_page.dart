import 'package:flutter/material.dart';
import '../widgets/history_app_bar.dart';
import '../widgets/history_card.dart';
import '../widgets/history_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),

      //preferencialmente mudar o background pra branco mesmo;
      appBar: const HistoryAppBar(),

      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(16), child: HistorySearch()),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('participations')
                  .where(
                    'userId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final participations = snapshot.data!.docs;

                if (participations.isEmpty) {
                  return const Center(
                    child: Text(
                      'Você ainda não participou de nenhum evento.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: participations.length,
                  itemBuilder: (context, index) {
                    final participation = participations[index];

                    return HistoryCard(
                      title: participation['eventTitle'],
                      organization: participation['organization'],
                      eventId: participation['eventId'],
                    );
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
