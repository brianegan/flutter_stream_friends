library flutter_stream_widget;

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// A widget that rebuilds when the [Stream] it is listening to changes.
abstract class StreamWidget<WidgetModel> extends StatefulWidget {
  /// Creates a widget that listens to a stream.
  StreamWidget({Key key}) : super(key: key);

  /// Override this function to build widgets that depend on the current value
  /// of the [WidgetModel].
  Widget build(BuildContext context, WidgetModel widgetModel);

  /// If you're working with an async stream, the first time your Widget builds,
  /// the WidgetModel will be empty! Therefore, you can build a loading Widget!
  ///
  /// If the operation is going to take a long time to complete, you could
  /// provide some form of loading indicator. If the data should be delivered
  /// almost instantly, you could consider using this default implementation.
  /// If you've got several default values, you could also use this method
  /// to provide an initial state to your build method like so:
  ///
  ///     Widget buildLoading(BuildContext context) =>
  ///         // Call the normal build method, providing a WidgetModel with
  ///         // some default values
  ///         build(context, new WidgetModel(isLoading: true, count: 0))
  Widget buildLoading(BuildContext context) => new Container();

  /// You can create custom logic to control whether or not the loading view
  /// should show. By default, if the WidgetModel is not present, buildLoading
  /// will be called.
  ///
  /// Be mindful when overriding this method: If your method returns false, and
  /// the WidgetModel is null, you'll most likely encounter a rendering
  /// error!
  @mustCallSuper
  bool isLoading(WidgetModel widgetModel) {
    return widgetModel == null;
  }

  Stream<WidgetModel> createStream();

  @override
  StreamWidgetState<WidgetModel> createState() =>
      new StreamWidgetState<WidgetModel>();
}

class StreamWidgetState<WidgetModel> extends State<StreamWidget<WidgetModel>> {
  WidgetModel _widgetModel;
  StreamSubscription<WidgetModel> subscription;

  StreamWidgetState();

  @override
  void initState() {
    subscription = config.createStream().distinct().listen((latestModel) {
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
  Widget build(BuildContext context) => config.isLoading(_widgetModel)
      ? config.buildLoading(context)
      : config.build(context, _widgetModel);
}
