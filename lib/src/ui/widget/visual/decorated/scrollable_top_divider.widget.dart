import 'package:flutter/material.dart';

final class TopDividerConfig {
  const TopDividerConfig({
    this.show = true,
    this.color = Colors.black12,
    this.thickness = 1,
    this.duration = const Duration(milliseconds: 320),
    this.curve = Curves.decelerate,
  });

  final bool show;
  final Color color;
  final double thickness;
  final Duration duration;
  final Curve curve;
}

class ScrollableTopDivider extends StatefulWidget {
  const ScrollableTopDivider({
    super.key,
    this.config = const TopDividerConfig(),
    required this.child,
  });

  final TopDividerConfig config;
  final Widget child;

  @override
  State<ScrollableTopDivider> createState() => _ScrollableTopDividerState();
}

class _ScrollableTopDividerState extends State<ScrollableTopDivider> {
  bool _showTopDivider = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels > 0 && !_showTopDivider) {
          setState(() {
            _showTopDivider = true;
          });
        } else if (notification.metrics.pixels <= 0) {
          setState(() {
            _showTopDivider = false;
          });
        }
        return false;
      },
      child: AnimatedContainer(
        duration: widget.config.duration,
        curve: widget.config.curve,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _showTopDivider
                  ? widget.config.color
                  : widget.config.color.withOpacity(0),
              width: widget.config.thickness,
            ),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
