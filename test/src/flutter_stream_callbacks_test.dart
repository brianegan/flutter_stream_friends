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

    test('VoidStreamCallback should be a VoidCallback',
        () => expect(new VoidStreamCallback() is VoidCallback, isTrue));

    test(
        'DragDownStreamCallback should be a DragDownCallback',
        () => expect(
            new DragDownStreamCallback() is GestureDragDownCallback, isTrue));

    test(
        'DragStartStreamCallback should be a DragStartCallback',
        () => expect(
            new DragStartStreamCallback() is GestureDragStartCallback, isTrue));

    test(
        'DragUpdateStreamCallback should be a DragUpdateCallback',
        () => expect(
            new DragUpdateStreamCallback() is GestureDragUpdateCallback,
            isTrue));

    test(
        'DragEndStreamCallback should be a DragEndCallback',
        () => expect(
            new DragEndStreamCallback() is GestureDragEndCallback, isTrue));

    test(
        'DragCancelStreamCallback should be a DragCancelCallback',
        () => expect(
            new DragCancelStreamCallback() is GestureDragCancelCallback,
            isTrue));

    test(
        'LongPressCallback should be a LongCallback',
        () => expect(
            new LongPressStreamCallback() is GestureLongPressCallback, isTrue));

    test(
        'MultiTapDownStreamCallback should be a MultiTapDownCallback',
        () => expect(
            new MultiTapDownStreamCallback() is GestureMultiTapDownCallback,
            isTrue));

    test(
        'MultiTapUpStreamCallback should be a MultiTapUpCallback',
        () => expect(
            new MultiTapUpStreamCallback() is GestureMultiTapUpCallback,
            isTrue));

    test(
        'MultiTapStreamCallback should be a MultiTapCallback',
        () => expect(
            new MultiTapStreamCallback() is GestureMultiTapCallback, isTrue));

    test(
        'MultiTapCancelStreamCallback should be a MultiTapCancelCallback',
        () => expect(
            new MultiTapCancelStreamCallback() is GestureMultiTapCancelCallback,
            isTrue));

    test(
        'MultiTapDownStreamCallback should be a TapCallback',
        () => expect(
            new MultiTapDownStreamCallback() is GestureMultiTapDownCallback,
            isTrue));

    test(
        'MultiTapUpStreamCallback should be a TapCancelCallback',
        () => expect(
            new MultiTapUpStreamCallback() is GestureMultiTapUpCallback,
            isTrue));

    test(
        'ScaleStartStreamCallback should be a ScaleStartCallback',
        () => expect(
            new ScaleStartStreamCallback() is GestureScaleStartCallback,
            isTrue));

    test(
        'ScaleUpdateStreamCallback should be a ScaleUpdateCallback',
        () => expect(
            new ScaleUpdateStreamCallback() is GestureScaleUpdateCallback,
            isTrue));

    test(
        'ScaleEndStreamCallback should be a ScaleEndCallback',
        () => expect(
            new ScaleEndStreamCallback() is GestureScaleEndCallback, isTrue));

    test(
        'TapDownStreamCallback should be a TapDownCallback',
        () => expect(
            new TapDownStreamCallback() is GestureTapDownCallback, isTrue));

    test(
        'TapUpStreamCallback should be a TapUpCallback',
        () =>
            expect(new TapUpStreamCallback() is GestureTapUpCallback, isTrue));

    test('TapStreamCallback should be a TapCallback',
        () => expect(new TapStreamCallback() is GestureTapCallback, isTrue));

    test(
        'TapCancelStreamCallback should be a TapCancelCallback',
        () => expect(
            new TapCancelStreamCallback() is GestureTapCancelCallback, isTrue));

    test(
        'DismissDirectionStreamCallback should be a TapCancelCallback',
        () => expect(
            new DismissDirectionStreamCallback() is DismissDirectionCallback,
            isTrue));

    test(
        'DraggableCanceledStreamCallback should be a DraggableCanceledCallback',
        () => expect(
            new DraggableCanceledStreamCallback() is DraggableCanceledCallback,
            isTrue));

    test(
        'ValueChangedStreamCallback should be a generic ValueChanged<T>',
        () => expect(
              new ValueChangedStreamCallback<String>() is ValueChanged<String>,
              isTrue,
            ));

    test('RefreshStreamCallback should be a generic RefreshCallback', () {
      expect(
        new RefreshStreamCallback() is RefreshCallback,
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
