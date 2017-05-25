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

  /// If you're working with an async str`eam, the first time your Widget builds,
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

  /// Create a stream that will deliver the necessary data for the Widget
  ///
  /// Instead of creating local state variables and managing those with
  /// individual handlers and setters, simply create a stream that continuously
  /// delivers new data to your Widget. When new data is delivered, the Widget
  /// will be rebuilt.
  Stream<WidgetModel> createStream();

  @override
  StreamWidgetState<WidgetModel> createState() =>
      new StreamWidgetState<WidgetModel>();
}

/// The State for a StreamWidget
///
///
class StreamWidgetState<WidgetModel> extends State<StreamWidget<WidgetModel>> {
  WidgetModel _widgetModel;
  StreamSubscription<WidgetModel> _subscription;

  @override
  void initState() {
    _subscription =
        widget.createStream().distinct().listen((WidgetModel latestModel) {
      this.setState(() {
        _widgetModel = latestModel;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.isLoading(_widgetModel)
      ? widget.buildLoading(context)
      : widget.build(context, _widgetModel);
}
