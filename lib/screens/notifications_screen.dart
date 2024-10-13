import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:afrik_flow/models/notification.dart' as notification_model;
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(userProvider)?.notifications;

    if (notifications == null || notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsDuotone.bellSlash,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Pas encore de notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Vous recevrez des notifications ici',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    void markNotificationAsRead(int id) async {
      await _apiService.markNotificationAsRead(id, ref);
    }

    void markAllNotificationsAsRead() async {
      await _apiService.markNotificationsAsRead(ref);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              markAllNotificationsAsRead();
            },
            icon: const Icon(PhosphorIconsDuotone.checkCircle),
            label: const Text(
              'Tout marquer comme lu',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return Slidable(
                key: ValueKey(notification.id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      markNotificationAsRead(notification.id);
                    },
                  ),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        markNotificationAsRead(notification.id);
                      },
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      icon: PhosphorIconsDuotone.check,
                      label: 'Marquer comme lue',
                    ),
                  ],
                ),
                child: NotificationTile(
                  notification: notification,
                  markNotificationAsRead: markNotificationAsRead,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NotificationTile extends StatelessWidget {
  final notification_model.Notification notification;
  final Function markNotificationAsRead;

  const NotificationTile(
      {super.key,
      required this.notification,
      required this.markNotificationAsRead});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: notification.isRead ? Colors.grey[300] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 90),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: Icon(
            _getIcon(notification.type),
            color: AppTheme.primaryColor,
            size: 30,
          ),
          title: Text(
            _truncateText(notification.message, 45),
            style: TextStyle(
                fontWeight:
                    notification.isRead ? FontWeight.normal : FontWeight.bold,
                color: Colors.black,
                fontSize: 14),
          ),
          subtitle: Text(
            notification.humarizeDate,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          trailing: notification.transaction != null
              ? const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey)
              : null,
          onTap: () {
            if (notification.transaction != null) {
              markNotificationAsRead(notification.id);
              context.push('/transaction-details',
                  extra: notification.transaction);
            } else if (notification.type ==
                notification_model.Notification.WELCOME) {
              markNotificationAsRead(notification.id);
              context.push('/send');
            }
          },
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case notification_model.Notification.PROMOTION:
        return PhosphorIconsDuotone.tag;
      case notification_model.Notification.INFO:
        return PhosphorIconsDuotone.info;
      case notification_model.Notification.ALERT:
        return PhosphorIconsDuotone.warningCircle;
      case notification_model.Notification.WELCOME:
        return PhosphorIconsDuotone.star;
      case notification_model.Notification.TRANSFERT:
        return PhosphorIconsDuotone.currencyCircleDollar;
      default:
        return PhosphorIconsDuotone.bell;
    }
  }

  String _truncateText(String text, int maxLength) {
    return text.length > maxLength
        ? '${text.substring(0, maxLength)}...'
        : text;
  }
}
