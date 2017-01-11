import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class TestStreamWidget extends StreamWidget<String> {
  static const String init = "init";
  static const String buildState = "build";
  static const String buildLoadingState = "buildLoading";

  final Stream<String> testStream;
  String currentState = "";
  String lifeCycle = init;

  TestStreamWidget(String initialState, this.testStream, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context, String widgetModel) {
    currentState = widgetModel;
    lifeCycle = buildState;

    return new Text(widgetModel);
  }

  @override
  Widget buildLoading(BuildContext context) {
    lifeCycle = buildLoadingState;
    return super.buildLoading(context);
  }

  @override
  bool isLoading(String widgetModel) {
    return super.isLoading(widgetModel);
  }

  @override
  Stream<String> createStream() {
    return testStream;
  }
}
