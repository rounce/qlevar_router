import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../../qlevar_router.dart';

import 'qoverlay.dart';

/// Show a panel in any router you have in your project
class QPanel extends StatefulWidget with QOverlay {
  /// The Position where the notification should displayed
  final QPanelPosition position;

  /// The offset from the Notification position With this offset, you can move
  /// the notification position for example for up or down left or right
  final Offset offset;

  /// The Notification width
  final double? width;

  /// The notification height
  final double? height;

  /// the animation Duration in Milliseconds when the notification opens
  final int animationDurationMilliseconds;

  /// the reverse animation Duration in Milliseconds when the
  /// notification closes
  final int? animationReverseDurationMilliseconds;

  /// The animation curve for the notification when opens
  final Curve animationCurve;

  /// The animation curve for the notification when closes
  final Curve? animationReverseCurve;

  final Widget child;

  @override
  final Duration? duration;

  /// A work to do when the notification is open
  final VoidCallback? onOpened;

  /// A work to do when the notification is closed
  final VoidCallback? onClosed;

  /// The notification color
  final Color? color;

  /// when this is true, a blur will be added to the background
  final bool isFloating;

  /// can this panael be closed when user click on the background
  /// when the user click on the background, the panal will be closed and
  /// no value will be returned
  final bool isDismissible;

  @override
  final String? overlayKey;

  QPanel({
    required this.child,
    this.position = QPanelPosition.Bottom,
    this.offset = Offset.zero,
    this.height,
    this.overlayKey,
    this.isFloating = false,
    this.isDismissible = true,
    this.animationDurationMilliseconds = 800,
    this.animationReverseDurationMilliseconds = 800,
    this.animationCurve = Curves.fastLinearToSlowEaseIn,
    this.animationReverseCurve,
    this.width,
    this.duration,
    this.onClosed,
    this.onOpened,
    this.color,
  });

  _PanelState? _state;

  @override
  _PanelState createState() {
    final state = _PanelState();
    _state = state;
    return state;
  }

  @override
  Future<T?> show<T>({String? name}) async {
    if (name == null) {
      return await QR.rootNavigator.show(this);
    }
    return await QR.navigatorOf(name).show(this);
  }

  Offset _calcPosition(BuildContext context) {
    Offset result;
    switch (position) {
      case QPanelPosition.Right:
        result = Offset(context.size!.width, 0);
        break;
      case QPanelPosition.Bottom:
        result = Offset(0, context.size!.height - 50);
        break;
      case QPanelPosition.Left:
      case QPanelPosition.Top:
      default:
        result = Offset.zero;
    }
    return Offset(result.dx + offset.dx, result.dy + offset.dy);
  }

  @override
  List<OverlayEntry> buildEntries<T>(BuildContext context) {
    final p = _calcPosition(context);
    return [
      if (!isFloating)
        OverlayEntry(
          builder: (context) => GestureDetector(
            onTap: () => QR.overlays.remove(this),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      OverlayEntry(
        builder: (context) => Positioned(
          left: p.dx,
          top: p.dy,
          child: this,
        ),
      )
    ];
  }

  @override
  TickerFuture get remove => _state!.remove();
}

class _PanelState extends State<QPanel> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.animationDurationMilliseconds),
    reverseDuration: widget.animationReverseDurationMilliseconds == null
        ? null
        : Duration(milliseconds: widget.animationDurationMilliseconds),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: _clacBeginOffset(),
    end: _clacEndOffset(),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: widget.animationCurve,
    reverseCurve: widget.animationReverseCurve,
  ));

  @override
  void initState() {
    super.initState();
    _controller.forward().then((value) {
      if (widget.onOpened != null) {
        widget.onOpened!();
      }
    });
  }

  Offset _clacBeginOffset() {
    switch (widget.position) {
      case QPanelPosition.Left:
        return const Offset(-1, 0);
      case QPanelPosition.Top:
        return const Offset(0, -1);
      case QPanelPosition.Bottom:
        return const Offset(0, 1);
      case QPanelPosition.Right:
      default:
        return const Offset(0, 0);
    }
  }

  Offset _clacEndOffset() {
    switch (widget.position) {
      case QPanelPosition.Right:
        return const Offset(-1, 0);
      case QPanelPosition.Top:
      case QPanelPosition.Bottom:
      case QPanelPosition.Left:
      default:
        return const Offset(0, 0);
    }
  }

  TickerFuture remove() => _controller.reverse();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _offsetAnimation,
        child: Material(
            color: widget.isFloating
                ? Theme.of(context).backgroundColor
                : widget.color,
            child: SafeArea(
                bottom: widget.position == QPanelPosition.Bottom,
                top: widget.position == QPanelPosition.Top,
                left: widget.position == QPanelPosition.Left,
                right: widget.position == QPanelPosition.Right,
                child: Container(
                  width: _getWidth(),
                  height: _getHeight(),
                  child: widget.child,
                  decoration: BoxDecoration(
                      // borderRadius:
                      //     BorderRadius.circular(widget.borderRadius),
                      ),
                ))));
  }

  double? _getWidth() {
    switch (widget.position) {
      case QPanelPosition.Left:
      case QPanelPosition.Right:
        return widget.width ?? MediaQuery.of(context).size.width * 0.25;
      case QPanelPosition.Top:
      case QPanelPosition.Bottom:
      default:
        return MediaQuery.of(context).size.width;
    }
  }

  double? _getHeight() {
    switch (widget.position) {
      case QPanelPosition.Left:
      case QPanelPosition.Right:
        return widget.height ?? MediaQuery.of(context).size.height;
      case QPanelPosition.Top:
      case QPanelPosition.Bottom:
      default:
        return widget.height ?? MediaQuery.of(context).size.height * 0.25;
    }
  }
}

/// The Position of QPanel
enum QPanelPosition {
  Top,
  Right,
  Left,
  Bottom,
}
