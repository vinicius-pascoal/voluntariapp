import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/perfil_page.dart';
import 'package:voluntariapp/models/app_user.dart';
import 'package:voluntariapp/services/user_service.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.size = 40, this.openProfile = true});

  final double size;
  final bool openProfile;

  @override
  Widget build(BuildContext context) {
    final avatar = StreamBuilder(
      stream: UserService().currentUserStream(),
      builder: (context, snapshot) {
        final photoUrl = snapshot.data?.photoUrl ?? '';
        if (photoUrl.trim().isNotEmpty) {
          return ClipOval(
            child: Image.network(
              photoUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            ),
          );
        }
        return _fallback();
      },
    );

    if (!openProfile) return avatar;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilPage()),
        );
      },
      borderRadius: BorderRadius.circular(size / 2),
      child: avatar,
    );
  }

  Widget _fallback() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD9D9D9),
      ),
      child: Icon(Icons.person, color: Colors.white, size: size * 0.65),
    );
  }
}
