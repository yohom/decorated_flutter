import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

/// 显示运行时信息的widget
class Runtime extends StatefulWidget {
  const Runtime({
    Key key,
    @required this.runtimeInfo,
  }) : super(key: key);

  static void registerGlobalBLoCList(List<GlobalBLoC> blocs) {
    _globalBLoCList = blocs;
  }
  static List<GlobalBLoC> _globalBLoCList;

  final List<Event> runtimeInfo;

  @override
  _RuntimeState createState() => _RuntimeState();
}

class _RuntimeState extends State<Runtime> {
  bool _globalBLoCExpanded = true;
  bool _localBLoCExpanded = false;

  @override
  Widget build(BuildContext context) {
    final List<Event> globalEventList = Runtime._globalBLoCList
            ?.expand((bloc) => bloc.eventList)
            ?.toList() ??
        [];
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          setState(() {
            switch (index) {
              case 0:
                _globalBLoCExpanded = !isExpanded;
                break;
              case 1:
                _localBLoCExpanded = !isExpanded;
            }
          });
        },
        children: [
          // 全局BLoC运行时信息
          ExpansionPanel(
            isExpanded: _globalBLoCExpanded,
            headerBuilder: (_, __) => _Header(title: 'Global BLoCs'),
            body: _Body(eventList: globalEventList),
          ),
          // 局部BLoC运行时信息
          ExpansionPanel(
            isExpanded: _localBLoCExpanded,
            headerBuilder: (_, __) => _Header(title: 'Local BLoC'),
            body: _Body(eventList: widget.runtimeInfo),
          ),
        ],
      ),
    );
  }
}

/// ExpansionList的Header
class _Header extends StatelessWidget {
  const _Header({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}

/// ExpansionList的Body
class _Body extends StatelessWidget {
  const _Body({
    Key key,
    @required this.eventList,
  }) : super(key: key);

  final List<Event> eventList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: eventList?.length ?? 0,
      itemBuilder: (context, index) {
        final event = eventList[index];
        return StreamBuilder(
          stream: event.stream,
          builder: (_, __) {
            return ListTile(title: Text(event.runtimeSummary()));
          },
        );
      },
    );
  }
}
