import 'package:flutter/material.dart';

class ArcaInformationis extends StatelessWidget {
  const ArcaInformationis({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // TODO: ativar a cor da borda apenas quando clicar quando implementar estados
      decoration: BoxDecoration(
        color: const Color(0xFFDDE9FF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }
}
