import 'package:qlevar_router/qlevar_router.dart';

import '../screens/overlays/dialogs_page.dart';
import '../screens/overlays/notifications_page.dart';
import '../screens/overlays/overlays_page.dart';
import '../screens/overlays/panels_page.dart';

class OverlaysRoutes {
  static const nested = 'Nested';

  QRoute route() =>
      QRoute(path: '/overlays', builder: () => OverlaysPage(), children: [
        QRoute(path: '/dialogs', builder: () => DialogsPage()),
        QRoute(path: '/notifications', builder: () => NotificationsPage()),
        QRoute(path: '/panels', builder: () => PanelsPage()),
      ]);
}
