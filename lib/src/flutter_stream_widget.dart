library flutter_stream_widget;

import 'dart:async';
import 'package:flutter/widgets.dart';

/// A widget that rebuilds when the [Stream] it is listening to changes.
abstract class StreamWidget<WidgetModel> extends StatefulWidget {
  WidgetModel initialState;

  /// Creates a widget that listens to a stream.
  StreamWidget(this.initialState, { Key key }) : super(key: key);

  /// Override this function to build widgets that depend on the current value
  /// of the [WidgetModel].
  Widget build(BuildContext context, WidgetModel widgetModel);

  Stream<WidgetModel> createStream();

  @override
  StreamWidgetState<WidgetModel> createState() =>
    new StreamWidgetState<WidgetModel>(initialState);
}

class StreamWidgetState<WidgetModel> extends State<StreamWidget<WidgetModel>> {
  WidgetModel widgetModel;
  StreamSubscription<WidgetModel> subscription;

  StreamWidgetState(this.widgetModel);

  @override
  void initState() {
    subscription = config.createStream().distinct().listen((latestModel) {
      this.setState(() {
        widgetModel = latestModel;
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
  Widget build(BuildContext context) => config.build(context, widgetModel);
}
