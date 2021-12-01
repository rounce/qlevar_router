import 'package:flutter/widgets.dart';

// ignore: one_member_abstracts
mixin QOverlay {
  /// The duration to keep the overlay open
  /// if this value was null the overlay will not close automatically
  Duration? get duration;

  TickerFuture get remove;

  String? get overlayKey;

  /// Show this overlay on the navigator with [name].
  /// if name is null the overlay will be shown on the main navigator.
  Future<T?> show<T>({String? name});

  List<OverlayEntry> buildEntries<T>(BuildContext context);
}
