import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/page.dart';
import '../../helpers/qbutton.dart';

class OverlaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(Center(
        child: Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        QButton('Dialogs', () => QR.to('overlays/dialogs')),
        QButton('Notifications', () => QR.to('overlays/notifications')),
        QButton('Panels', () => QR.to('overlays/panels')),
      ],
    )));
  }
}
