import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class TestStreamWidget extends StreamWidget<String> {
  final Stream<String> testStream;
  String currentState = "";

  TestStreamWidget(String initialState, this.testStream, {Key key})
      : super(initialState, key: key);

  @override
  Widget build(BuildContext context, String widgetModel) {
    currentState = widgetModel;

    return new Text(widgetModel);
  }

  @override
  Stream<String> createStream() {
    return testStream;
  }
}
