import 'dart:math';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

@internal
class LogOverlay extends StatefulWidget {
  const LogOverlay({super.key, required this.talker, required this.onClose});

  final Talker talker;
  final VoidCallback onClose;

  @override
  State<LogOverlay> createState() => _LogOverlayState();
}

class _LogOverlayState extends State<LogOverlay> {
  static const _minimumSize = Size(240, 180);
  var _size = const Size(360, 480);
  var _offset = const Offset(16, 72);
  var _showNetworkOnly = false;

  @override
  Widget build(BuildContext context) {
    final available = MediaQuery.sizeOf(context);
    final size = Size(
        min(_size.width, available.width), min(_size.height, available.height));
    final offset = Offset(
      _offset.dx.clamp(0, max(0, available.width - size.width)).toDouble(),
      _offset.dy.clamp(0, max(0, available.height - size.height)).toDouble(),
    );
    return Stack(
      children: [
        Positioned(
          left: offset.dx,
          top: offset.dy,
          width: size.width,
          height: size.height,
          child: DecoratedColumn(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: const Color(0xCC171717),
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) => _move(details.delta, available, size),
                child: DecoratedRow(
                  color: const Color(0xE6000000),
                  children: [
                    DecoratedText(
                      '本地日志',
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      style: TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() => _showNetworkOnly = false),
                      child: Text(
                        '全部',
                        style: TextStyle(
                          color:
                              _showNetworkOnly ? Colors.white54 : Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _showNetworkOnly = true),
                      child: Text(
                        '网络',
                        style: TextStyle(
                          color:
                              _showNetworkOnly ? Colors.white : Colors.white54,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: '关闭日志',
                    ),
                  ],
                ),
              ),
              DecoratedStack(
                expanded: true,
                children: [
                  Positioned.fill(
                    child: _LogList(
                      talker: widget.talker,
                      networkOnly: _showNetworkOnly,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanUpdate: (details) =>
                          _resize(details.delta, available),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: _ResizeHandleIcon(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _move(Offset delta, Size available, Size size) {
    setState(() {
      _offset = Offset(
        (_offset.dx + delta.dx)
            .clamp(0, max(0, available.width - size.width))
            .toDouble(),
        (_offset.dy + delta.dy)
            .clamp(0, max(0, available.height - size.height))
            .toDouble(),
      );
    });
  }

  void _resize(Offset delta, Size available) {
    setState(() {
      _size = Size(
        (_size.width + delta.dx)
            .clamp(_minimumSize.width,
                max(_minimumSize.width, available.width - _offset.dx))
            .toDouble(),
        (_size.height + delta.dy)
            .clamp(_minimumSize.height,
                max(_minimumSize.height, available.height - _offset.dy))
            .toDouble(),
      );
    });
  }
}

class _LogList extends StatelessWidget {
  const _LogList({required this.talker, required this.networkOnly});

  final Talker talker;
  final bool networkOnly;

  @override
  Widget build(BuildContext context) {
    const theme = TalkerScreenTheme(
      backgroundColor: Colors.transparent,
      cardColor: Color(0xB3292929),
    );
    return TalkerBuilder(
      talker: talker,
      builder: (_, data) {
        final logs = data
            .where((item) {
              if (!networkOnly) return true;
              return item.key == TalkerKey.httpRequest ||
                  item.key == TalkerKey.httpResponse ||
                  item.key == TalkerKey.httpError;
            })
            .toList()
            .reversed
            .toList();
        return ListView.builder(
          padding: EdgeInsets.only(top: 12),
          itemCount: logs.length,
          itemBuilder: (_, index) {
            final log = logs[index];
            return TalkerDataCard(
              data: log,
              color: log.getFlutterColor(theme),
              backgroundColor: theme.cardColor,
            );
          },
        );
      },
    );
  }
}

class _ResizeHandleIcon extends StatelessWidget {
  const _ResizeHandleIcon();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(20, 20),
      painter: _ResizeHandlePainter(),
    );
  }
}

class _ResizeHandlePainter extends CustomPainter {
  const _ResizeHandlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(3, 13)
        ..quadraticBezierTo(10, 13, 13, 3),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(7, 18)
        ..quadraticBezierTo(17, 18, 18, 7),
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
