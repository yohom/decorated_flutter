import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart';

const fetchCaptcha = '获取验证码';
const refetchCaptcha = '重新获取';
const countDown = '倒计时%s秒';

typedef Widget _Builder(VoidCallback onPressed, String title);

/// [OnFetchCaptcha]的返回值代表身份继续获取, 因为有时候需要检查参数, 如果参数不符合要求就不能
/// 获取验证码
typedef bool OnFetchCaptcha();

/// 倒计时控件
class CountdownBuilder extends StatefulWidget {
  const CountdownBuilder(
    this._timer, {
    Key key,
    @required this.onFetchCaptcha,
    this.duration = const Duration(seconds: 60),
    this.beforeFetchTitle = fetchCaptcha,
    this.refetchTitle = refetchCaptcha,
    this.countDownLabel = countDown,
    this.builder,
  }) : super(key: key);

  final Observable _timer;
  final _Builder builder;
  final OnFetchCaptcha onFetchCaptcha;
  final Duration duration;
  final String beforeFetchTitle;
  final String refetchTitle;
  final String countDownLabel;

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountdownBuilder> {
  VoidCallback _onPressed;
  VoidCallback _onActivePressed;
  String _title;
  StreamSubscription<CountdownTimer> _subscription;

  @override
  void initState() {
    super.initState();
    _title = widget.beforeFetchTitle;

    _onActivePressed = () {
      if (!widget.onFetchCaptcha()) return;

      _subscription = widget._timer.listen((count) {
        setState(() {
          _title = widget.countDownLabel.replaceFirst(
            '%s',
            count.remaining.inSeconds.toString(),
          );
          _onPressed = null;
        });
      }, onDone: () {
        _subscription.cancel();
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
