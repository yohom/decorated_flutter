import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/annotation/experiment.dart';
import 'package:flutter/material.dart';

typedef Widget _Data2WidgetCallback<T>(T data);

@experiment
class IncrementalListView<T> extends StatelessWidget {
  const IncrementalListView({
    Key key,
    @required this.stream,
    @required this.mapper,
  })  : assert(stream != null),
        assert(mapper != null),
        super(key: key);

  final Stream<T> stream;
  final _Data2WidgetCallback mapper;

  final List<T> cachedData = const [];

  @override
  Widget build(BuildContext context) {
    return PreferredStreamBuilder(
      stream: stream,
      builder: (data) {
        cachedData.add(data);
        return ListView(children: cachedData.map(mapper));
      },
    );
  }
}
