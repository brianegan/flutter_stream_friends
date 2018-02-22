import 'dart:async';

import 'package:flutter/widgets.dart';

/// A class that listens to a [ScrollController] and emits a null value every
/// time the user scrolls near the bottom of a list.
///
/// You must attach the ScrollController to a ListView or GridView in order for
/// this Stream to begin emitting values.
///
/// Please note: This stream will emit lots of items when the user is scrolling
/// near the bottom of a list. If you are loading data in response to this
/// Stream, make sure you don't spam your web server or database. See the
/// exhaustMap, debounce, or throttle methods from RxDart for solutions
/// to this problem.
class InfiniteScrollStream extends StreamView<Null> {
  final ScrollController scrollController;

  /// Constructor for InfiniteScrollStream.
  ///
  /// You can optionally provide a [ScrollController]. If you do not, a
  /// ScrollController will be created for you.
  ///
  /// In addition, you can specify how close the ScrollController should be to
  /// the end before it begins emitting values using [pixelsFromBottom].
  factory InfiniteScrollStream({
    ScrollController scrollController,
    int pixelsFromBottom: 500,
  }) {
    final _scrollController = scrollController ?? new ScrollController();
    final streamController = new StreamController<Null>.broadcast(sync: true);
    final listener = () {
      final extent = _scrollController.position.maxScrollExtent;
      final offset = _scrollController.offset;

      if (extent - offset < pixelsFromBottom) {
        streamController.add(null);
      }
    };

    // Start listening to the ScrollController
    _scrollController.addListener(listener);

    // Ensure we clean up the StreamController and Listener
    streamController.onCancel = () {
      _scrollController.removeListener(listener);
      return streamController.close();
    };

    return new InfiniteScrollStream._(
      _scrollController,
      streamController.stream,
    );
  }

  InfiniteScrollStream._(this.scrollController, Stream<Null> stream)
      : super(stream);
}
