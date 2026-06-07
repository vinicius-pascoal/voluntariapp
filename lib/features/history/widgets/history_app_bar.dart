import 'package:flutter/material.dart';
import 'package:voluntariapp/features/notificacoes/pages/notificacoes.dart';
import 'package:voluntariapp/features/perfil/perfil_page.dart';

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HistoryAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,

      // leading: Icon(
      //   Icons.arrow_back, color: Color(0xFFFFA500),
      //   size: 40,
      // ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          //Icons.arrow_back_ios_new,
          size: 40,
          color: Color(0xFFFFA500),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      //DDE9FF cor background no figma
      backgroundColor: Colors.transparent,

      title: const Text(
        'Histórico',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),

      centerTitle: true,

      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFFFFA500),
            size: 28,
          ),
          tooltip: 'Ver notificações',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notificacoes()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Color(0xFFFFA500), size: 40),
          tooltip: 'Página de Perfil',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PerfilPage()),
            );
          },
        ),
      ],
    );
  }
}
