import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

const fetchCaptcha = '获取验证码';
const refetchCaptcha = '重新获取';
const countDown = '倒计时%s秒';

typedef Widget _Builder(VoidCallback onPressed, String title);

/// 倒计时控件
class CountDownBuilder extends StatefulWidget {
  final _Builder builder;
  final VoidCallback onFetchCaptcha;
  final Duration duration;
  final String beforeFetchTitle;
  final String refetchTitle;
  final String countDownLabel;

  const CountDownBuilder({
    Key key,
    @required this.onFetchCaptcha,
    this.duration = const Duration(seconds: 60),
    this.beforeFetchTitle = fetchCaptcha,
    this.refetchTitle = refetchCaptcha,
    this.countDownLabel = countDown,
    this.builder,
  }) : super(key: key);

  @override
  _CountDownState createState() {
    return _CountDownState();
  }
}

class _CountDownState extends State<CountDownBuilder> {
  static Observable<int> get timer => Observable<int>.periodic(
        Duration(seconds: 1),
        (data) => 59 - data,
      ).take(60);

  static StreamSubscription<int> subscription;

  VoidCallback _onPressed;
  VoidCallback _onActivePressed;
  String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.beforeFetchTitle;

    _onActivePressed = () {
      widget.onFetchCaptcha();

      subscription = timer.listen((count) {
        setState(() {
          _title = countDown.replaceFirst('%s', count.toString());
          _onPressed = null;
        });
      }, onDone: () {
        subscription.cancel();
        _title = widget.refetchTitle;
        setState(() => _onPressed = _onActivePressed);
      });
    };

    _onPressed = _onActivePressed;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_onPressed, _title);
  }
}
