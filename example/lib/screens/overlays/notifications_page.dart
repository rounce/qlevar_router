import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/page.dart';
import '../../helpers/qbutton.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QButton("LeftTop",
                        () => showNotification(QNotificationPosition.LeftTop)),
                    QButton("Top",
                        () => showNotification(QNotificationPosition.Top)),
                    QButton("RightTop",
                        () => showNotification(QNotificationPosition.RightTop)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QButton(
                        "LeftCenter",
                        () =>
                            showNotification(QNotificationPosition.LeftCenter)),
                    QButton("Center",
                        () => showNotification(QNotificationPosition.Center)),
                    QButton(
                        "RightCenter",
                        () => showNotification(
                            QNotificationPosition.RightCenter)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QButton(
                        "LeftBottom",
                        () =>
                            showNotification(QNotificationPosition.LeftBottom)),
                    QButton("Bottom",
                        () => showNotification(QNotificationPosition.Bottom)),
                    QButton(
                        "RightBottom",
                        () => showNotification(
                            QNotificationPosition.RightBottom)),
                  ],
                ),
              ],
            ))));
  }

  void showNotification(QNotificationPosition position) {
    final notificationChild = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          FlutterLogo(size: 50.0),
          SizedBox(width: 6),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('New Notification', style: TextStyle(fontSize: 18)),
              Text(
                'Hello World',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ],
      ),
    );

    QNotification(child: notificationChild, position: position).show();
  }
}
