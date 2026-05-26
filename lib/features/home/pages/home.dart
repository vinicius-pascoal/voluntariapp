import 'package:flutter/material.dart';
import 'package:voluntariapp/features/notificacoes/pages/notificacoes.dart';
import 'package:voluntariapp/features/detalhesEvento/detalhes_evento.dart';
import 'package:voluntariapp/features/perfil/perfil_page.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: _HomeHeader(),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(11, 0, 12, 16),
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return const EventCard(
                    organizationName: 'ONG Tal de Tal',
                    eventName: 'Nome do Evento',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur turpis quam, blandit scelerisque et nec, faucibus dictum purus. Proin finibus gravida metus',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                const Icon(
                  Icons.filter_list,
                  color: Color(0xFF49454F),
                  size: 27,
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    'Pesquisar',
                    style: TextStyle(
                      color: Color(0xFF49454F),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const Icon(Icons.search, color: Color(0xFF49454F), size: 25),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        const SizedBox(width: 11),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notificacoes()),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA500),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        const AppAvatar(size: 40),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.organizationName,
    required this.eventName,
    required this.description,
  });

  final String organizationName;
  final String eventName;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 343,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                const AppAvatar(size: 40),
                const SizedBox(width: 13),
                Text(
                  organizationName,
                  style: const TextStyle(
                    color: Color(0xFF727272),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 23),
            Text(
              eventName,
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  height: 1.24,
                  letterSpacing: 0.1,
                ),
                children: [TextSpan(text: description)],
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                height: 114,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Color(0xFF1F1F24),
                    size: 82,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 95,
                height: 39,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFFA500),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetalhesEvento()),
                    );
                  },
                  child: const Text(
                    'Detalhes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.size = 40});

  final double size;

  //adicionar onclick para ir para a página de perfil do usuário
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilPage()),
        );
      },
      borderRadius: BorderRadius.circular(size / 2),
      child: ClipOval(
        child: Image.network(
          'https://picsum.photos/200',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFD9D9D9),
              ),
              child: Icon(Icons.person, color: Colors.white, size: size * 0.65),
            );
          },
        ),
      ),
    );
  }
}
