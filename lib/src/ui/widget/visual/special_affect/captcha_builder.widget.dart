import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

enum CaptchaState {
  /// 初始状态
  init,

  /// 等待下一次可获取状态
  wait,

  /// 可再次获取状态
  retry,
}

class CaptchaBuilder extends StatefulWidget {
  static Widget _defaultInitBuilder(BuildContext context) {
    return const Text('获取验证码');
  }

  static Widget _defaultWaitBuilder(BuildContext context, int count) {
    return Text('再次获取($count)');
  }

  static Widget _defaultRetryBuilder(BuildContext context) {
    return const Text('再次获取');
  }

  const CaptchaBuilder({
    Key? key,
    required this.stateIO,
    this.initValue = 60,
    this.initBuilder = _defaultInitBuilder,
    this.waitBuilder = _defaultWaitBuilder,
    this.retryBuilder = _defaultRetryBuilder,
    required this.onFetchCaptcha,
    this.width,
    this.height,
  }) : super(key: key);

  final IO<CaptchaState> stateIO;
  final int initValue;
  final WidgetBuilder initBuilder;
  final Widget Function(BuildContext, int) waitBuilder;
  final WidgetBuilder retryBuilder;
  final Future<void> Function(BuildContext) onFetchCaptcha;
  final double? width, height;

  @override
  State<CaptchaBuilder> createState() => _CaptchaBuilderState();
}

class _CaptchaBuilderState extends State<CaptchaBuilder> {
  int _attempts = 0;

  @override
  Widget build(BuildContext context) {
    Widget result = StreamBuilder<CaptchaState>(
      initialData: CaptchaState.init,
      stream: widget.stateIO.stream,
      builder: (_, snapshot) {
        final data = snapshot.requireData;
        switch (data) {
          case CaptchaState.wait:
            return Countdown(
              key: Key('_CaptchaBuilderState_$_attempts'),
              initialData: widget.initValue,
              builder: widget.waitBuilder,
              onZero: () => widget.stateIO.add(CaptchaState.retry),
            );
          case CaptchaState.retry:
            return GestureDetector(
              onTap: () => widget
                  .onFetchCaptcha(context)
                  .then((_) => widget.stateIO.add(CaptchaState.wait))
                  .then((value) => setState(() => ++_attempts))
                  .catchError(handleError),
              child: widget.retryBuilder(context),
            );
          case CaptchaState.init:
          default:
            return GestureDetector(
              onTap: () => widget
                  .onFetchCaptcha(context)
                  .then((_) => widget.stateIO.add(CaptchaState.wait))
                  .then((value) => setState(() => ++_attempts))
                  .catchError(handleError),
              child: widget.initBuilder(context),
            );
        }
      },
    );

    if (widget.width != null || widget.height != null) {
      result = SizedBox(
        width: widget.width,
        height: widget.height,
        child: result,
      );
    }

    return result;
  }
}
