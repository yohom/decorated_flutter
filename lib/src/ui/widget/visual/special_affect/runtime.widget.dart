import 'package:decorated_flutter/src/bloc/bloc.dart';
import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/material.dart';

/// 显示运行时信息的widget
class Runtime extends StatefulWidget {
  const Runtime({
    Key? key,
    this.runtimeInfo = const <BaseIO>[],
  }) : super(key: key);

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
    final List<BaseIO> globalIOList =
        // ignore: invalid_use_of_protected_member
        Runtime._globalBLoCList.expand((bloc) => bloc.disposeBag).toList();
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
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
            body: _Body(ioList: globalIOList),
          ),
          // 局部BLoC运行时信息
          ExpansionPanel(
            isExpanded: _localBLoCExpanded,
            headerBuilder: (_, __) => _Header(title: 'Local BLoC'),
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
    Key? key,
    required this.title,
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
    Key? key,
    required this.ioList,
  }) : super(key: key);

  final List<BaseIO> ioList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: ioList.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(ioList[index].runtimeSummary()));
      },
    );
  }
}
