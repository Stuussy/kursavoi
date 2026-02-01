import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Notifications screen (Хабарламалар экраны)
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notifications data
    final notifications = [
      _NotificationItem(
        icon: Icons.restaurant,
        title: 'Брондау расталды',
        message: 'Сіздің "La Piazza" ресторанындағы брондауыңыз расталды.',
        time: '2 сағат бұрын',
        isRead: false,
      ),
      _NotificationItem(
        icon: Icons.star,
        title: 'Жаңа ресторан',
        message: 'Жаңа ресторан "Sushi Master" қосылды. Тексеріп көріңіз!',
        time: '1 күн бұрын',
        isRead: true,
      ),
      _NotificationItem(
        icon: Icons.percent,
        title: 'Арнайы ұсыныс',
        message: 'Осы аптада барлық брондаулар үшін 10% жеңілдік!',
        time: '2 күн бұрын',
        isRead: true,
      ),
      _NotificationItem(
        icon: Icons.check_circle,
        title: 'Брондау аяқталды',
        message: '"Burger House" ресторанына барғаныңыз үшін рахмет!',
        time: '5 күн бұрын',
        isRead: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Хабарламалар'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Барлығы оқылды деп белгіленді'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Барлығын оқу',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Хабарламалар жоқ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(notification: notification);
              },
            ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  _NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppTheme.surfaceColor
            : AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead
              ? AppTheme.textSecondaryColor.withOpacity(0.1)
              : AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification.icon,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                              ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
