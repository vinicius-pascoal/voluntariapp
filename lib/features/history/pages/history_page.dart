import 'package:flutter/material.dart';

import '../widgets/history_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/history_card.dart';
import '../widgets/history_search.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDE9FF),

      //preferencialmente mudar o background pra branco mesmo;
      appBar: HistoryAppBar(),

      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: HistorySearch()),

          Expanded(
            child: ListView.builder(
              itemCount: 8,

              itemBuilder: (context, index) {
                return HistoryCard();
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigation(),
    );
  }
}
