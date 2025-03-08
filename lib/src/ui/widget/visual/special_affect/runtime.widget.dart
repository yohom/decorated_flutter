import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/material.dart';

/// 显示运行时信息的widget
class Runtime extends StatefulWidget {
  const Runtime({
    super.key,
    this.runtimeInfo = const <BaseIO>[],
  });

  static void registerGlobalBLoCList(List<GlobalBLoC> blocs) {
    _globalBLoCList = blocs;
  }

  static List<GlobalBLoC> _globalBLoCList = [];

  final List<BaseIO> runtimeInfo;

  @override
  _RuntimeState createState() => _RuntimeState();
}

class _RuntimeState extends State<Runtime> {
  bool _globalBLoCExpanded = false;
  bool _localBLoCExpanded = true;

  @override
  Widget build(BuildContext context) {
    final List<BaseIO> globalIOList = Runtime._globalBLoCList
        // ignore: invalid_use_of_protected_member
        .expand((bloc) => bloc.disposeBag.whereType<BaseIO>())
        .toList();
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
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
            headerBuilder: (_, __) => const _Header(title: 'Global BLoCs'),
            body: _Body(ioList: globalIOList),
          ),
          // 局部BLoC运行时信息
          ExpansionPanel(
            isExpanded: _localBLoCExpanded,
            headerBuilder: (_, __) => const _Header(title: 'Local BLoC'),
            body: _Body(ioList: widget.runtimeInfo),
          ),
        ],
      ),
    );
  }
}

/// ExpansionList的Header
class _Header extends StatelessWidget {
  const _Header({
    required this.title,
  });

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
    required this.ioList,
  });

  final List<BaseIO> ioList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: ioList.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(ioList[index].runtimeSummary()));
      },
    );
  }
}
