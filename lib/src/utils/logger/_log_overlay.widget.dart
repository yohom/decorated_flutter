import 'dart:math';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Talker 暂未公开导出日志文件分享控制器
// ignore: implementation_imports
import 'package:talker_flutter/src/controller/talker_view_controller.dart';
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
  static const _minimizedSize = Size(52, 52);
  static const _minimizedBottomMargin = 80.0;
  var _size = const Size(360, 480);
  var _offset = const Offset(16, 72);
  Offset? _minimizedOffset;
  var _isMinimized = true;
  var _isDragging = false;
  var _showNetworkOnly = false;

  Duration get _animationDuration =>
      _isDragging ? Duration.zero : const Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final available = MediaQuery.sizeOf(context);
    final minimizedOffset = Offset(
      available.width - _minimizedSize.width - 16,
      available.height -
          _minimizedSize.height -
          MediaQuery.paddingOf(context).bottom -
          _minimizedBottomMargin,
    );
    final expandedSize = Size(
      min(_size.width, available.width),
      min(_size.height, available.height),
    );
    final expandedOffset = Offset(
      _offset.dx
          .clamp(0, max(0, available.width - expandedSize.width))
          .toDouble(),
      _offset.dy
          .clamp(0, max(0, available.height - expandedSize.height))
          .toDouble(),
    );
    return Stack(
      children: [
        AnimatedPositioned(
          duration: _animationDuration,
          curve: Curves.easeInOutCubic,
          left: _isMinimized
              ? (_minimizedOffset ?? minimizedOffset).dx
              : expandedOffset.dx,
          top: _isMinimized
              ? (_minimizedOffset ?? minimizedOffset).dy
              : expandedOffset.dy,
          width: _isMinimized ? _minimizedSize.width : expandedSize.width,
          height: _isMinimized ? _minimizedSize.height : expandedSize.height,
          child: AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.easeInOutCubic,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: const Color(0xCC171717),
              borderRadius: BorderRadius.circular(_isMinimized ? 26 : 12),
            ),
            child: _isMinimized
                ? _buildMinimized(available)
                : _buildExpanded(available, expandedSize),
          ),
        ),
      ],
    );
  }

  Widget _buildExpanded(Size available, Size size) {
    return DecoratedColumn(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (_) => setState(() => _isDragging = true),
          onPanUpdate: (details) => _move(details.delta, available, size),
          onPanEnd: (_) => setState(() => _isDragging = false),
          child: DecoratedRow(
            color: const Color(0xE6000000),
            children: [
              IconButton(
                onPressed: () {
                  widget.talker.cleanHistory();
                  setState(() {});
                },
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: '清空日志',
              ),
              IconButton(
                onPressed: () => _shareLogs(),
                icon: const Icon(Icons.ios_share_outlined, color: Colors.white),
                tooltip: '分享日志',
              ),
              const Spacer(),
              IconButton(
                onPressed: () =>
                    setState(() => _showNetworkOnly = !_showNetworkOnly),
                icon: Icon(
                  Icons.http,
                  color: _showNetworkOnly ? Colors.white : Colors.white54,
                ),
                tooltip: _showNetworkOnly ? '显示全部日志' : '仅显示网络日志',
              ),
              IconButton(
                onPressed: () => _minimize(
                  available,
                  MediaQuery.paddingOf(context).bottom,
                ),
                icon: const Icon(Icons.minimize, color: Colors.white),
                tooltip: '最小化日志',
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
                onPanStart: (_) => setState(() => _isDragging = true),
                onPanUpdate: (details) => _resize(details.delta, available),
                onPanEnd: (_) => setState(() => _isDragging = false),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: _ResizeHandleIcon(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMinimized(Size available) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _isMinimized = false),
      onPanStart: (_) => setState(() => _isDragging = true),
      onPanUpdate: (details) => _move(details.delta, available, _minimizedSize),
      onPanEnd: (_) => setState(() => _isDragging = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: const Color(0xE6000000),
          borderRadius: BorderRadius.circular(26),
        ),
        child: const Center(
          child: Icon(Icons.article_outlined, color: Colors.white),
        ),
      ),
    );
  }

  void _minimize(Size available, double bottomSafeArea) {
    setState(() {
      _minimizedOffset ??= Offset(
        available.width - _minimizedSize.width - 16,
        available.height -
            _minimizedSize.height -
            bottomSafeArea -
            _minimizedBottomMargin,
      );
      _isMinimized = true;
    });
  }

  Future<void> _shareLogs() {
    return TalkerViewController(talker: widget.talker).downloadLogsFile(
      widget.talker.history.text(
        timeFormat: widget.talker.settings.timeFormat,
      ),
    );
  }

  void _move(Offset delta, Size available, Size size) {
    setState(() {
      if (_isMinimized) {
        final currentOffset = _minimizedOffset ??
            Offset(
              available.width - _minimizedSize.width - 16,
              available.height - _minimizedSize.height - _minimizedBottomMargin,
            );
        _minimizedOffset = _clampOffset(
          currentOffset + delta,
          available,
          size,
        );
        return;
      }
      _offset = _clampOffset(_offset + delta, available, size);
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

  Offset _clampOffset(Offset offset, Size available, Size size) {
    return Offset(
      offset.dx.clamp(0, max(0, available.width - size.width)).toDouble(),
      offset.dy.clamp(0, max(0, available.height - size.height)).toDouble(),
    );
  }
}

class _LogList extends StatefulWidget {
  const _LogList({required this.talker, required this.networkOnly});

  final Talker talker;
  final bool networkOnly;

  @override
  State<_LogList> createState() => _LogListState();
}

class _LogListState extends State<_LogList> {
  final _scrollController = ScrollController();
  TalkerData? _latestLog;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const theme = TalkerScreenTheme(
      backgroundColor: Colors.transparent,
      cardColor: Color(0xB3292929),
    );
    return TalkerBuilder(
      talker: widget.talker,
      builder: (_, data) {
        final logs = data
            .where((item) {
              if (!widget.networkOnly) return true;
              return item.key == TalkerKey.httpRequest ||
                  item.key == TalkerKey.httpResponse ||
                  item.key == TalkerKey.httpError;
            })
            .toList()
            .reversed
            .toList();
        final latestLog = logs.isEmpty ? null : logs.first;
        if (latestLog != null && !identical(latestLog, _latestLog)) {
          _latestLog = latestLog;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients &&
                _scrollController.position.pixels > 0) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
              );
            }
          });
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 12),
          itemCount: logs.length,
          itemBuilder: (_, index) {
            final log = logs[index];
            final card = TalkerDataCard(
              key: ValueKey(log),
              data: log,
              color: log.getFlutterColor(theme),
              backgroundColor: theme.cardColor,
            );
            if (index != 0) return card;
            return TweenAnimationBuilder<double>(
              key: ValueKey(log),
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              builder: (_, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, -12 * (1 - value)),
                  child: child,
                ),
              ),
              child: card,
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
