import 'package:flutter/material.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_circle_left_outlined,
          color: Colors.orange,
          size: 40,
        ),
        //DDE9FF cor background
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
              color: Colors.orange,
              size: 28,
            ),
            tooltip: 'Ver notificações',
            onPressed: () {
              // lógica do botão
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.orange, size: 40),
            tooltip: 'Página de Perfil',
            onPressed: () {
              // lógica do botão
            },
          ),
        ],
      ),
      body: Container(
          
      ),
    );
  }
}
