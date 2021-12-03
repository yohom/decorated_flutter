import 'package:decorated_flutter/src/extension/build_context.x.dart';
import 'package:decorated_flutter/src/ui/ui.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.height,
    this.width,
    this.margin,
    this.color,
    this.backgroundColor,
    this.sliver = false,
    this.material = false,
  }) : super(key: key);

  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final Color? color;
  final Color? backgroundColor;
  final bool sliver;
  final bool material;

  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: material
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                color ?? Theme.of(context).primaryColor,
              ),
            )
          : const CupertinoActivityIndicator(),
    );
    if (height != null || width != null) {
      result = SizedBox(height: height, width: width, child: result);
    }
    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }
    if (backgroundColor != null) {
      result = Container(color: backgroundColor, child: result);
    }
    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}

class ModalLoading extends StatelessWidget {
  const ModalLoading(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black12,
      child: Center(
        child: DecoratedColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(context.theme.primaryColor),
            ),
            // 有文本就加这个
            if (isNotEmpty(text))
              DecoratedText(
                text,
                margin: const EdgeInsets.only(top: 10),
                style: const TextStyle(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
