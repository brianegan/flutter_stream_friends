import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_stream_widget.dart';

void main() {
  group('StreamWidget', () {
    testWidgets('takes an optional initial value', (WidgetTester tester) async {
      StreamController<String> streamController =
          new StreamController.broadcast(sync: true);
      var widget = new TestStreamWidget("initial", streamController.stream);

      await tester.pumpWidget(widget);

      expect(widget.currentState, equals("initial"));
    });

    testWidgets('subscribes to the latest state', (WidgetTester tester) async {
      StreamController<String> streamController =
          new StreamController.broadcast(sync: true);
      var widget = new TestStreamWidget("initial", streamController.stream);
      var expected = "test";

      await tester.pumpWidget(widget);

      expect(streamController.hasListener, equals(true));

      streamController.add(expected);
      await tester.pumpWidget(widget);

      expect(widget.currentState, equals(expected));
    });

    testWidgets('unsubscribes on destroy', (WidgetTester tester) async {
      StreamController<String> streamController =
          new StreamController.broadcast(sync: true);
      var widget = new TestStreamWidget("", streamController.stream);

      await tester.pumpWidget(widget);
      expect(streamController.hasListener, equals(true));

      // Create a new Widget tree, which causes the test Widget to be disposed.
      await tester.pumpWidget(new Container());
      expect(streamController.hasListener, equals(false));
    });
  });
}
