import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

/// 可以设置在停止接收到[TextField]的[onChanged]方法多久后再触发[DebounceTextField]的
/// [onChanged]方法
/// 适用场景: [TextField]一边输入内容, 一边根据内容进行网络请求(或其他耗资源的操作), 这时需要
/// 根据输入的节奏来调整网络请求的次数, [duration]参数可以设置在用户停止输入多久之后, 开始网络
/// 请求(或其他耗资源操作).
class DebounceTextField extends StatefulWidget {
  /// change触发方法
  final ValueChanged<String> onChanged;

  /// 延迟多少时间触发[onChanged]方法
  final Duration duration;

  // 以下属性为TextField的属性
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final int maxLines;
  final int maxLength;
  final bool maxLengthEnforced;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final TextInputAction textInputAction;

  DebounceTextField({
    Key key,
    this.onChanged,
    this.duration = const Duration(milliseconds: 500),
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    TextInputType keyboardType = TextInputType.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.textInputAction,
  })  : assert(keyboardType != null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(maxLengthEnforced != null),
        assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : TextInputType.multiline,
        super(key: key);

  @override
  _DebounceTextFieldState createState() => _DebounceTextFieldState();
}

class _DebounceTextFieldState extends State<DebounceTextField> {
  final _subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    _subject.debounceTime(widget.duration).listen(widget.onChanged);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => _subject.add(text),
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      style: widget.style,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      maxLengthEnforced: widget.maxLengthEnforced,
      onSubmitted: widget.onSubmitted,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
    );
  }

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }
}
