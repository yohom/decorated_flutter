import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

/// 显示运行时信息的widget
class Runtime extends StatelessWidget {
  const Runtime({
    Key key,
    @required this.runtimeInfo,
  }) : super(key: key);

  final List<Event> runtimeInfo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ExpansionPanelList(
        children: [
          ExpansionPanel(
            headerBuilder: (context, isExpanded) => Text('Global BLoCs'),
            body: ListView.builder(
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
          ExpansionPanel(
            headerBuilder: (context, isExpanded) => Text('Local BLoCs'),
            body: ListView.builder(
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
        ],
      ),
    );
  }
}
