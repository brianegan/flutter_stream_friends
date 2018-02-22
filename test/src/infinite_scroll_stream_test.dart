import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InfiniteScrollStream', () {
    test('should create a ScrollController if none provided', () {
      final stream = new InfiniteScrollStream();

      expect(stream.scrollController, new isInstanceOf<ScrollController>());
    });

    testWidgets('emits items when it reaches the end of a ScrollController',
        (WidgetTester tester) async {
      final stream = new InfiniteScrollStream();
      final widget = _buildWidget(stream);
      final items = <Null>[];

      stream.listen(items.add);

      await tester.pumpWidget(widget);
      stream.scrollController.jumpTo(2500.0);

      expect(items, [null, null]);
    });

    testWidgets('does not emit items if Scrolling near the top',
        (WidgetTester tester) async {
      final stream = new InfiniteScrollStream();
      final widget = _buildWidget(stream);
      final items = <Null>[];

      stream.listen(items.add);

      await tester.pumpWidget(widget);
      stream.scrollController.jumpTo(100.0);

      expect(items, isEmpty);
    });

    testWidgets('stops emitting items after the subscription is cancelled',
        (WidgetTester tester) async {
      final stream = new InfiniteScrollStream();
      final widget = _buildWidget(stream);
      final items = <Null>[];
      final subscription = stream.listen(items.add);

      await tester.pumpWidget(widget);
      stream.scrollController.jumpTo(2300.0);

      expect(items, [null, null]);

      // ignore: unawaited_futures
      subscription.cancel();

      stream.scrollController.jumpTo(2500.0);

      expect(items, [null, null]);
      expect(stream, neverEmits(anything));
    });
  });
}

final _key = new Key("List");

MaterialApp _buildWidget(InfiniteScrollStream stream) {
  return new MaterialApp(
    home: new Scaffold(
      body: new ListView(
        controller: stream.scrollController,
        key: _key,
        children: [
          new ListItem(1),
          new ListItem(2),
          new ListItem(3),
          new ListItem(4),
          new ListItem(5),
        ],
      ),
    ),
  );
}

class ListItem extends StatelessWidget {
  final int position;

  ListItem(this.position);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 500.0,
      child: new Text("$position"),
    );
  }
}
