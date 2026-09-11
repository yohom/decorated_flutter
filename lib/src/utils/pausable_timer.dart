import 'dart:async';

class PausableTimer {
  PausableTimer(
    this.duration,
    this.onDone, {
    this.executeImmediately = true,
    this.repeat = true,
  }) : _remaining = duration;

  final Duration duration;
  final void Function() onDone;
  final bool executeImmediately;
  final bool repeat;

  Timer? _timer;
  final Stopwatch _watch = Stopwatch();
  late Duration _remaining;

  bool get isRunning => _timer?.isActive ?? false;
  Duration get remaining => _remaining;

  void start() {
    if (isRunning || _remaining <= Duration.zero) return;

    _watch
      ..reset()
      ..start();

    _timer = Timer(_remaining, _handleTimerFinished);

    if (executeImmediately) onDone();
  }

  void pause() {
    if (!isRunning) return;

    _timer?.cancel();
    _timer = null;

    _watch.stop();
    final elapsed = _watch.elapsed;

    _remaining = elapsed >= _remaining ? Duration.zero : _remaining - elapsed;
  }

  void resume() => start();

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
  }

  void _handleTimerFinished() {
    _watch.stop();

    if (!repeat) {
      _remaining = Duration.zero;
      _timer = null;
      onDone();
      return;
    }

    _remaining = duration;
    _watch
      ..reset()
      ..start();
    _timer = Timer(duration, _handleTimerFinished);
    onDone();
  }
}
