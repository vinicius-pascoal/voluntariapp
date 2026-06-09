import 'package:flutter/material.dart';
import 'package:voluntariapp/models/app_notification.dart';
import 'package:voluntariapp/services/notification_service.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class Notificacoes extends StatelessWidget {
  const Notificacoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _NotificationHeader(onBackTap: () => Navigator.maybePop(context)),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: StreamBuilder<List<AppNotification>>(
                stream: NotificationService().getUserNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final notifications = snapshot.data ?? [];
                  if (notifications.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Nenhuma notificação encontrada. Confirme presença em eventos para receber lembretes.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 0, 8, 24),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationCard(notification: notification);
                    },
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

class _NotificationHeader extends StatelessWidget {
  const _NotificationHeader({required this.onBackTap});

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBackTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA500),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3.5),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 25),
              ),
            ),
          ),
          const Text(
            'Notificações',
            style: TextStyle(color: Color(0xFF0D0D0D), fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NotificationService().markAsRead(notification.id),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minHeight: 150),
        decoration: BoxDecoration(
          color: notification.read ? const Color(0xFFF9F9F9) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: notification.read ? null : Border.all(color: const Color(0xFFFFA500), width: 1.2),
          boxShadow: const [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 4)],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 15, 42, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(color: Color(0xFF1E1E1E), fontSize: 23, fontWeight: FontWeight.w700, height: 1.1),
                        ),
                      ),
                      if (!notification.read)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(color: Color(0xFFFFA500), shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.description,
                    style: const TextStyle(color: Color(0xFF757575), fontSize: 16, fontWeight: FontWeight.w400, height: 1.35, letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.read ? 'Lida' : 'Toque para marcar como lida',
                    style: TextStyle(color: notification.read ? Colors.black45 : const Color(0xFFFFA500), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Positioned(top: 6, right: 14, child: Icon(Icons.notifications, color: Color(0xFF757575), size: 20)),
          ],
        ),
      ),
    );
  }
}
