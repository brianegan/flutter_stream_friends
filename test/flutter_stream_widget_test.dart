import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_stream_widget.dart';

void main() {
  group('StreamWidget', () {
    testWidgets('runs buildLoading before any data has been delivered',
        (WidgetTester tester) async {
      final streamController = new StreamController<String>.broadcast();
      final widget = new TestStreamWidget("init", streamController.stream);

      await tester.pumpWidget(widget);

      await streamController.close();

      expect(widget.lifeCycle, equals(TestStreamWidget.buildLoadingState));
    });

    testWidgets('subscribes to the latest state', (WidgetTester tester) async {
      final streamController =
          new StreamController<String>.broadcast(sync: true);
      final widget = new TestStreamWidget("initial", streamController.stream);
      final expected = "test";

      await tester.pumpWidget(widget);

      expect(streamController.hasListener, equals(true));

      streamController.add(expected);
      await tester.pumpWidget(widget);

      await streamController.close();

      expect(widget.currentState, equals(expected));
    });

    testWidgets('unsubscribes on destroy', (WidgetTester tester) async {
      final streamController =
          new StreamController<String>.broadcast(sync: true);
      final widget = new TestStreamWidget("", streamController.stream);

      await tester.pumpWidget(widget);
      expect(streamController.hasListener, equals(true));

      // Create a new Widget tree, which causes the test Widget to be disposed.
      await tester.pumpWidget(new Container());
      expect(streamController.hasListener, equals(false));

      await streamController.close();
    });
  });
}
