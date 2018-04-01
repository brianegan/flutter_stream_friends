import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StreamCallbacks', () {
    testWidgets('should act as a stream and callback',
        (WidgetTester tester) async {
      final streamCallback = new TapStreamCallback();
      final key = new Key("test");
      final widget = new GestureDetector(key: key, onTap: streamCallback);
      var wasTapped = false;

      await tester.pumpWidget(widget);

      streamCallback.listen((_) => wasTapped = true);

      await tester.tap(find.byKey(key));

      expect(wasTapped, isTrue);
    });

    testWidgets('should act as a stream and callback with a value',
        (WidgetTester tester) async {
      final streamCallback = new TapDownStreamCallback();
      final key = new Key("test");
      final widget = new GestureDetector(key: key, onTapDown: streamCallback);
      Offset position;

      await tester.pumpWidget(widget);

      streamCallback
          .listen((TapDownDetails tap) => position = tap.globalPosition);

      await tester.tap(find.byKey(key));

      expect(position, isNotNull);
    });

    test(
        'VoidStreamCallback should be a VoidCallback',
        () => expect(
              new VoidStreamCallback().call is VoidCallback,
              isTrue,
            ));

    test(
        'DragDownStreamCallback should be a DragDownCallback',
        () => expect(
              new DragDownStreamCallback().call is GestureDragDownCallback,
              isTrue,
            ));

    test(
        'DragStartStreamCallback should be a DragStartCallback',
        () => expect(
              new DragStartStreamCallback().call is GestureDragStartCallback,
              isTrue,
            ));

    test(
        'DragUpdateStreamCallback should be a DragUpdateCallback',
        () => expect(
              new DragUpdateStreamCallback().call is GestureDragUpdateCallback,
              isTrue,
            ));

    test(
        'DragEndStreamCallback should be a DragEndCallback',
        () => expect(
              new DragEndStreamCallback().call is GestureDragEndCallback,
              isTrue,
            ));

    test(
        'DragCancelStreamCallback should be a DragCancelCallback',
        () => expect(
              new DragCancelStreamCallback().call is GestureDragCancelCallback,
              isTrue,
            ));

    test(
        'LongPressCallback should be a LongCallback',
        () => expect(
              new LongPressStreamCallback().call is GestureLongPressCallback,
              isTrue,
            ));

    test(
        'MultiTapDownStreamCallback should be a MultiTapDownCallback',
        () => expect(
              new MultiTapDownStreamCallback().call
                  is GestureMultiTapDownCallback,
              isTrue,
            ));

    test(
        'MultiTapUpStreamCallback should be a MultiTapUpCallback',
        () => expect(
              new MultiTapUpStreamCallback().call is GestureMultiTapUpCallback,
              isTrue,
            ));

    test(
        'MultiTapStreamCallback should be a MultiTapCallback',
        () => expect(
              new MultiTapStreamCallback().call is GestureMultiTapCallback,
              isTrue,
            ));

    test(
        'MultiTapCancelStreamCallback should be a MultiTapCancelCallback',
        () => expect(
              new MultiTapCancelStreamCallback().call
                  is GestureMultiTapCancelCallback,
              isTrue,
            ));

    test(
        'MultiTapDownStreamCallback should be a TapCallback',
        () => expect(
              new MultiTapDownStreamCallback().call
                  is GestureMultiTapDownCallback,
              isTrue,
            ));

    test(
        'MultiTapUpStreamCallback should be a TapCancelCallback',
        () => expect(
              new MultiTapUpStreamCallback().call is GestureMultiTapUpCallback,
              isTrue,
            ));

    test(
        'ScaleStartStreamCallback should be a ScaleStartCallback',
        () => expect(
              new ScaleStartStreamCallback().call is GestureScaleStartCallback,
              isTrue,
            ));

    test(
        'ScaleUpdateStreamCallback should be a ScaleUpdateCallback',
        () => expect(
              new ScaleUpdateStreamCallback().call
                  is GestureScaleUpdateCallback,
              isTrue,
            ));

    test(
        'ScaleEndStreamCallback should be a ScaleEndCallback',
        () => expect(
              new ScaleEndStreamCallback().call is GestureScaleEndCallback,
              isTrue,
            ));

    test(
        'TapDownStreamCallback should be a TapDownCallback',
        () => expect(
              new TapDownStreamCallback().call is GestureTapDownCallback,
              isTrue,
            ));

    test(
        'TapUpStreamCallback should be a TapUpCallback',
        () => expect(
              new TapUpStreamCallback().call is GestureTapUpCallback,
              isTrue,
            ));

    test(
        'TapStreamCallback should be a TapCallback',
        () => expect(
              new TapStreamCallback().call is GestureTapCallback,
              isTrue,
            ));

    test(
        'TapCancelStreamCallback should be a TapCancelCallback',
        () => expect(
              new TapCancelStreamCallback().call is GestureTapCancelCallback,
              isTrue,
            ));

    test(
        'DismissDirectionStreamCallback should be a TapCancelCallback',
        () => expect(
              new DismissDirectionStreamCallback().call
                  is DismissDirectionCallback,
              isTrue,
            ));

    test(
        'DraggableCanceledStreamCallback should be a DraggableCanceledCallback',
        () => expect(
              new DraggableCanceledStreamCallback().call
                  is DraggableCanceledCallback,
              isTrue,
            ));

    test(
        'ValueChangedStreamCallback should be a generic ValueChanged<T>',
        () => expect(
              new ValueChangedStreamCallback<String>().call
                  is ValueChanged<String>,
              isTrue,
            ));

    test('RefreshStreamCallback should be a generic RefreshCallback', () {
      expect(
        new RefreshStreamCallback().call is RefreshCallback,
        isTrue,
      );
    });

    test('RefreshStreamCallback can be completed', () {
      final callback = new RefreshStreamCallback();

      callback.listen((completer) => completer.complete());

      expect(callback(), completes);
    });

    test('RefreshStreamCallback is not completed by default', () {
      final callback = new RefreshStreamCallback();

      expect(callback(), doesNotComplete);
    });

    test('StreamController is closed after subscriptions are cancelled', () {
      final callback = new VoidStreamCallback();
      final subscription = callback.listen((_) {});

      subscription.cancel();

      expect(callback.streamController.done, completes);
      expect(() => callback(), throwsStateError);
    });
  });
}
