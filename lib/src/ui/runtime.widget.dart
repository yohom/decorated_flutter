import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

/// 显示运行时信息的widget
class Runtime extends StatelessWidget {
  const Runtime({
    Key key,
    @required this.child,
    @required this.runtimeInfo,
  }) : super(key: key);

  final Widget child;
  final List<Event> runtimeInfo;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          child,
          Positioned(
            bottom: kSpaceZero,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                constraints: BoxConstraints(maxHeight: Global.screenHeight / 3),
                width: Global.screenWidth,
                color: Colors.grey.withOpacity(0.6),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: kSpaceNormal),
                  shrinkWrap: true,
                  itemCount: runtimeInfo.length,
                  itemBuilder: (context, index) {
                    final event = runtimeInfo[index];
                    return StreamBuilder(
                      stream: event.stream,
                      builder: (_, __) {
                        return Text(event.runtimeSummary());
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
