import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new StreamWidgetDemo('Reactive Flutter Demo'),
    );
  }
}

class StreamWidgetDemo extends StreamWidget<StreamWidgetDemoModel> {
  static int get increment => 1;
  static int get startingValue => 0;

  // Normal state that can be passed into this component
  final String title;

  StreamWidgetDemo(this.title, {Key key}) : super(key: key);

  /// When the component is initially built, createStream will be called and the
  /// resulting stream will be listened to. When any new events are added to
  /// the stream, the `Widget` will call `setState` with the value of the event.
  @override
  Stream<StreamWidgetDemoModel> createStream() {
    // Here, we create a StreamCallback. This acts as both a stream and
    // callback. This will be used as a stream informing us when the button has
    // been tapped, and as the event handler on the FAB. Once set on the FAB in
    // the build method, it will begin emitting events!
    var onFabPressed = new VoidStreamCallback();

    return new Observable(onFabPressed) // Every time the FAB is clicked
        .map((_) => increment) // Emit the value of inc (1 in this case)
        .scan(
            (int a, int b, int i) => a + b, // Add that 1 to the total
            startingValue)
        .startWith(startingValue)
        .map((int count) {
      // Convert the latest count and the event handler into the Widget Model
      return new StreamWidgetDemoModel(count, onFabPressed);
    });
  }

  // The latest value of the StreamWidgetDemoModel from the created stream is
  // passed into the this version of the build function!
  Widget build(BuildContext context, StreamWidgetDemoModel model) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Text(
          'Button tapped ${ model.count } time${ model.count == 1
              ? ''
              : 's' }.',
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        // Use the `StreamCallback` here to wire up the events to the Stream.
        onPressed: model.onFabPressed,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  // Because Streams are async in nature, it's common for the model to be
  // unavailable when it's first rendered. In order to handle the case when
  // data is loading, or the Stream is async, StreamWidget provides a hook
  // to handle exactly how to handle this case.
  //
  // In our case, we'll simply provide a default Model to get our app
  // kickstarted, then the stream Will take over as the first event is sent
  // down.
  @override
  Widget buildLoading(BuildContext context) =>
      build(context, new StreamWidgetDemoModel(0, () {}));
}

class StreamWidgetDemoModel {
  final int count;
  final VoidCallback onFabPressed;

  StreamWidgetDemoModel(this.count, this.onFabPressed);

  // If you've got a custom data model for your widget, it's best to implement
  // the == method in order to take advantage the performance optimizations
  // offered by the `Streams#distinct()` method. This will ensure the Widget is
  // repainted only when the Model has truly changed.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is StreamWidgetDemoModel && this.count == other.count;
  }

  @override
  int get hashCode {
    return count.hashCode;
  }

  @override
  String toString() {
    return 'StreamWidgetDemoModel{count: $count, onFabPressed: $onFabPressed}';
  }
}
