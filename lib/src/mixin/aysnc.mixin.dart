import 'package:decorated_flutter/src/ui/widget/visual/preferred/preferred_async_builder.widget.dart';
import 'package:flutter/widgets.dart';

mixin FutureMixin<DATA> on StatelessWidget {
  Widget build(BuildContext context) {
    return PreferredFutureBuilder<DATA>(
      future: future,
      builder: bump,
    );
  }

  Future<DATA> future;

  Widget bump(DATA data);
}

mixin StreamMixin<DATA> on StatelessWidget {
  Widget build(BuildContext context) {
    return PreferredStreamBuilder<DATA>(
      stream: stream,
      builder: bump,
    );
  }

  Stream<DATA> stream;

  Widget bump(DATA data);
}
