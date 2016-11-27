library flutter_stream_widget;

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// A widget that rebuilds when the [Stream] it is listening to changes.
abstract class StreamWidget<WidgetModel> extends StatefulWidget {
  WidgetModel initialState;

  /// Creates a widget that listens to a stream.
  StreamWidget({this.initialState, Key key}) : super(key: key);

  /// Override this function to build widgets that depend on the current value
  /// of the [WidgetModel].
  @protected
  Widget build(BuildContext context, WidgetModel widgetModel);

  @protected
  Stream<WidgetModel> buildStream();

  @override
  StreamWidgetState<WidgetModel> createState() =>
      new StreamWidgetState<WidgetModel>(initialState: initialState);
}

/// State for a [StreamWidget] widget.
class StreamWidgetState<WidgetModel> extends State<StreamWidget<WidgetModel>> {
  WidgetModel _widgetModel;
  StreamSubscription<WidgetModel> subscription;

  StreamWidgetState({WidgetModel initialState})
      : _widgetModel = initialState ?? null;

  @override
  void initState() {
    subscription = config.buildStream().listen((latestModel) {
      this.setState(() {
        _widgetModel = latestModel;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => config.build(context, _widgetModel);
}
