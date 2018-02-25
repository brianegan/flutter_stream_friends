import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  static String appTitle = "Flutter Stream Friends";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new StreamBuilder<CounterScreenModel>(
        stream: new CounterScreenStream(appTitle),
        initialData: new CounterScreenModel(0, () {}, appTitle),
        builder: (context, snapshot) => buildHome(context, snapshot.data),
      ),
    );
  }

  // The latest value of the CounterScreenModel from the CounterScreenStream is
  // passed into the this version of the build function!
  Widget buildHome(BuildContext context, CounterScreenModel model) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(model.title),
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
}

class CounterScreenStream extends StreamView<CounterScreenModel> {
  CounterScreenStream(
    String title, [
    VoidStreamCallback onFabPressed,
    int initialValue = 0,
  ])
      : super(createStream(
          title,
          onFabPressed ?? new VoidStreamCallback(),
          initialValue,
        ));

  // The method we use to create the stream that will continually deliver data
  // to the `buildHome` method.
  static Stream<CounterScreenModel> createStream(
    String title,
    VoidStreamCallback onFabPressed,
    int initialValue,
  ) {
    return new Observable(onFabPressed) // Every time the FAB is clicked
        .map((_) => 1) // Emit the value of 1
        .scan(
            (int a, int b, int i) => a + b, // Add that 1 to the total
            initialValue)
        // Before the button is clicked, kick everything off by emitting 0
        .startWith(initialValue)
        // Convert the latest count and the event handler into the Widget Model
        .map((int count) => new CounterScreenModel(count, onFabPressed, title));
  }
}

class CounterScreenModel {
  final String title;
  final int count;
  final VoidCallback onFabPressed;

  CounterScreenModel(this.count, this.onFabPressed, this.title);

  // If you've got a custom data model for your widget, it's best to implement
  // the == method in order to take advantage the performance optimizations
  // offered by the `Streams#distinct()` method. This will ensure the Widget is
  // repainted only when the Model has truly changed.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterScreenModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          count == other.count;

  @override
  int get hashCode => title.hashCode ^ count.hashCode;

  @override
  String toString() =>
      'CounterScreenModel{title: $title, count: $count, onFabPressed: $onFabPressed}';
}
