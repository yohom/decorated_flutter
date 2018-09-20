import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

const fetchCaptcha = '获取验证码';
const refetchCaptcha = '重新获取';
const countDown = '倒计时%s秒';

Observable<int> get timer => Observable<int>.periodic(
      Duration(seconds: 1),
      (data) => 59 - data,
    ).take(60);

StreamSubscription<int> subscription;

typedef Widget _Builder(VoidCallback onPressed, String title);

/// [OnFetchCaptcha]的返回值代表身份继续获取, 因为有时候需要检查参数, 如果参数不符合要求就不能
/// 获取验证码
typedef bool OnFetchCaptcha();

/// 倒计时控件
class CountDownBuilder extends StatefulWidget {
  final _Builder builder;
  final OnFetchCaptcha onFetchCaptcha;
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
  VoidCallback _onPressed;
  VoidCallback _onActivePressed;
  String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.beforeFetchTitle;

    _onActivePressed = () {
      if (!widget.onFetchCaptcha()) return;

      subscription = timer.listen((count) {
        setState(() {
          _title = widget.countDownLabel.replaceFirst('%s', count.toString());
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

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
