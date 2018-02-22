library flutter_stream_callbacks;

import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// It's a stream and a callback in one. It's a StreamCallback!
///
/// This class is meant to convert Flutter events, such as Taps or Drags, into a
/// Stream of those events. This is useful when creating applications that rely
/// more heavily on stream-based architectures.
abstract class StreamCallback<T> extends Stream<T> implements Function {
  /// When creating StreamCallbacks, you can simply implement the correct `call`
  /// method for the given callback you want to support, forwarding all event
  /// data into this streamController via `streamController.add(T)`
  final StreamController<T> streamController =
      new StreamController<T>.broadcast(sync: true);

  @override
  StreamSubscription<T> listen(
    void onData(T event), {
    Function onError,
    void onDone(),
    bool cancelOnError,
  }) {
    if (streamController.onCancel == null) {
      streamController.onCancel = () {
        streamController.close();
      };
    }

    return streamController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

/// Handles [VoidCallback] events
///
/// Unfortunately, you cannot create void value streams in Dart, in
/// the same way you can create a callback with no parameters. Therefore, the
/// Null class is used, and should be ignored.
class VoidStreamCallback extends StreamCallback<Null> {
  void call() => streamController.add(null);
}

/// The base single-value implementation
///
/// Extend this class with a simple type parameter to create a new
/// StreamCallback if the callback consists of only a single value.
class ValueStreamCallback<T> extends StreamCallback<T> {
  void call(T value) => streamController.add(value);
}

/// Handles [GestureDragDownCallback] events
class DragDownStreamCallback extends ValueStreamCallback<DragDownDetails> {}

/// Handles [GestureDragStartCallback] events
class DragStartStreamCallback extends ValueStreamCallback<DragStartDetails> {}

/// Handles [GestureDragUpdateCallback] events
class DragUpdateStreamCallback extends ValueStreamCallback<DragUpdateDetails> {}

/// Handles [GestureDragEndCallback] events
class DragEndStreamCallback extends ValueStreamCallback<DragEndDetails> {}

/// Handles [GestureDragCancelCallback] events
class DragCancelStreamCallback extends VoidStreamCallback {}

/// Handles [GestureLongPressCallback] events
class LongPressStreamCallback extends VoidStreamCallback {}

/// Handles [GestureMultiTapDownCallback] events
class MultiTapDownStreamCallback extends StreamCallback<MultiTapDownEvent> {
  void call(int pointer, TapDownDetails details) =>
      streamController.add(new MultiTapDownEvent(pointer, details));
}

/// Encapsulates all parameters of the [GestureMultiTapDownCallback] event
class MultiTapDownEvent {
  final int pointer;
  final TapDownDetails details;

  MultiTapDownEvent(this.pointer, this.details);
}

/// Handles [GestureMultiTapUpCallback] events
class MultiTapUpStreamCallback extends StreamCallback<MultiTapUpEvent> {
  void call(int pointer, TapUpDetails details) =>
      streamController.add(new MultiTapUpEvent(pointer, details));
}

/// Encapsulates all parameters of the [GestureMultiTapUpCallback] event
class MultiTapUpEvent {
  final int pointer;
  final TapUpDetails details;

  MultiTapUpEvent(this.pointer, this.details);
}

/// Handles [GestureMultiTapCallback] events
class MultiTapStreamCallback extends ValueStreamCallback<int> {}

/// Handles [GestureMultiTapCancelCallback] events
class MultiTapCancelStreamCallback extends ValueStreamCallback<int> {}

/// Handles [GestureScaleStartCallback] events
class ScaleStartStreamCallback extends ValueStreamCallback<ScaleStartDetails> {}

/// Handles [GestureScaleUpdateCallback] events
class ScaleUpdateStreamCallback
    extends ValueStreamCallback<ScaleUpdateDetails> {}

/// Handles [GestureScaleEndCallback] events
class ScaleEndStreamCallback extends ValueStreamCallback<ScaleEndDetails> {}

/// Handles [GestureTapDownCallback] events
class TapDownStreamCallback extends ValueStreamCallback<TapDownDetails> {}

/// Handles [GestureTapUpCallback] events
class TapUpStreamCallback extends ValueStreamCallback<TapUpDetails> {}

/// Handles [GestureTapCallback] events
class TapStreamCallback extends VoidStreamCallback {}

/// Handles [GestureTapCancelCallback] events
class TapCancelStreamCallback extends VoidStreamCallback {}

/// Handles [DismissDirectionCallback] events
class DismissDirectionStreamCallback
    extends ValueStreamCallback<DismissDirection> {}

/// Handles [DraggableCanceledCallback] events
class DraggableCanceledStreamCallback
    extends StreamCallback<DraggableCanceledEvent> {
  void call(Velocity velocity, Offset offset) =>
      streamController.add(new DraggableCanceledEvent(velocity, offset));
}

/// Encapsulates all parameters of the [DraggableCanceledCallback] event
class DraggableCanceledEvent {
  final Velocity velocity;
  final Offset offset;

  DraggableCanceledEvent(this.velocity, this.offset);
}

/// Handles generic [ValueChanged] events
class ValueChangedStreamCallback<T> extends StreamCallback<T> {
  void call(T value) => streamController.add(value);
}

/// Handles [RefreshCallback] events
///
/// In order to use a `RefreshIndicator` widget, you must provide a
/// `Future<Null>` to the `onRefresh` callback. When the `Future` completes,
/// the indicator will disappear.
///
/// This callback creates a `Completer<Null>` every time it is called. The
/// Completer is then emitted to any listener. You can then use
/// `completer.complete()` to indicate your async operation is done, and the
/// `RefreshIndicator` will be hidden.
class RefreshStreamCallback extends StreamCallback<Completer<Null>> {
  Future<Null> call() {
    final completer = new Completer<Null>();

    streamController.add(completer);

    return completer.future;
  }
}
