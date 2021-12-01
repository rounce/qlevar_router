import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../overlays/qoverlay.dart';

class OverlaysController {
  final _requests = <_OverlayRequest>[];

  Future<T?> add<T>(GlobalKey<NavigatorState> navKey, QOverlay overlay) async {
    final request = _OverlayRequest<T>(navKey, overlay);
    _requests.add(request);
    final _overlayState = navKey.currentState!.overlay!;
    _overlayState.insertAll(request.overlayEntries(navKey.currentContext!));

    if (overlay.duration != null) {
      request.timer = Timer(overlay.duration!, () {
        _remove(request);
      });
    }

    return request.completer.future;
  }

  void _remove(_OverlayRequest request) {
    request.cleanup();
    _requests.remove(request);
  }

  void remove(QOverlay overlay) {
    _remove(_requests.firstWhere((element) => element.overlay == overlay));
  }
}

class _OverlayRequest<T> {
  final String? name;
  final GlobalKey<NavigatorState> navKey;
  final QOverlay overlay;
  final completer = Completer<T?>();
  Timer? timer;
  _OverlayRequest(
    this.navKey,
    this.overlay, {
    this.name,
  });

  final _overlayEntries = <OverlayEntry>[];

  List<OverlayEntry> overlayEntries(BuildContext context) {
    _overlayEntries.clear();
    _overlayEntries.addAll(overlay.buildEntries(context));
    return _overlayEntries;
  }

  Future cleanup() async {
    timer?.cancel();
    timer = null;
    await overlay.remove;
    for (var item in _overlayEntries) {
      item.remove();
    }
    _overlayEntries.clear();
  }
}
