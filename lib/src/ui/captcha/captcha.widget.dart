import 'package:flutter/material.dart';
import 'package:decorated_flutter/src/ui/captcha/captcha_controller.dart';

const _kInitLabel = '获取验证码';
const _kRefetchLabel = '重新获取';
const _kLabelTemplate = '倒计时%s秒';

typedef Widget _Builder(bool enabled, String label);

/// 倒计时控件
/// 目标:
///   1. 倒计时过程中被dispose之后, 继续倒计时, 当重新显示时, 显示当前的倒计时(如果倒计时没
/// 有结束)
///   2. 倒计时过程中, 不可点击
///   3. 一轮倒计时结束后, 自动复原到初始值
///   4. 自动管理所有注册的定时器
class CaptchaBuilder extends StatefulWidget {
  CaptchaBuilder({
    Key key,
    @required this.controller,
    this.labelTemplate = _kLabelTemplate,
    this.initLabel = _kInitLabel,
    this.refetchLabel = _kRefetchLabel,
    @required this.builder,
  }) : super(key: key);

  /// Controller
  final CaptchaController controller;

  /// 文字模板, 实际的倒计时时间会代替模板中的`%s`字符
  final String labelTemplate;

  /// 初始文字
  final String initLabel;

  /// 重新获取的文字
  final String refetchLabel;

  /// 根据是否enable, 拼凑出来的label新建一个目标Widget
  final _Builder builder;

  @override
  _CaptchaBuilderState createState() => _CaptchaBuilderState();
}

class _CaptchaBuilderState extends State<CaptchaBuilder> {
  String _label;
  bool _enabled;

  @override
  void initState() {
    super.initState();

    widget.controller.disposed = false;

    if (widget.controller.started) {
      _enabled = widget.controller.remain == kDuration;
      _label = widget.labelTemplate
          .replaceFirst('%s', widget.controller.remain.toString());
    } else {
      _label = widget.initLabel;
      _enabled = true;
    }

    widget.controller.addListener(() {
      if (!widget.controller.disposed) {
        setState(() {
          if (widget.controller.done) {
            _enabled = true;
            _label = widget.refetchLabel;
          } else {
            _enabled = widget.controller.remain == kDuration;
            _label = widget.labelTemplate
                .replaceFirst('%s', widget.controller.remain.toString());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_enabled, _label);
  }

  @override
  void dispose() {
    widget.controller.disposed = true;
    super.dispose();
  }
}
