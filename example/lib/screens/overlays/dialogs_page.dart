import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/page.dart';
import '../../helpers/qbutton.dart';

class DialogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                // QButton(
                //     "Show AlertDialog",
                //     () => QR.show(QDialog(
                //         widget: (pop) =>
                //             AlertDialog(title: Text('Hi Dialog'))))),
                // QButton("Show Text Dialog",
                //     () => QDialog.text(text: Text('Simple Text')).show()),
                // QButton("Wait on Result", () async {
                //   final result = await QR.show<String>(QDialog(
                //       widget: (pop) => AlertDialog(
                //             title: Text('Hi Dialog'),
                //             actions: [
                //               TextButton(
                //                   onPressed: () => pop('Yes'),
                //                   child: Text('Yes')),
                //               TextButton(
                //                   onPressed: () => pop('No'), child: Text('No'))
                //             ],
                //           )));
                //   final notificationChild = Padding(
                //     padding:
                //         const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                //     child: Row(
                //       children: [
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text('Dialog result is:',
                //                 style: TextStyle(fontSize: 18)),
                //             Text(
                //               result ?? 'Canceld',
                //               style: TextStyle(fontSize: 14),
                //             )
                //           ],
                //         ),
                //       ],
                //     ),
                //   );

                //   QNotification(
                //           child: notificationChild,
                //           position: QNotificationPosition.RightBottom)
                //       .show();
                // }),
              ],
            ))));
  }
}
