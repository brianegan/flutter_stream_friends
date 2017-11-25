# flutter_stream_friends

[![Build Status](https://travis-ci.org/brianegan/flutter_stream_friends.svg?branch=master)](https://travis-ci.org/brianegan/flutter_stream_friends)  [![codecov](https://codecov.io/gh/brianegan/flutter_stream_friends/branch/master/graph/badge.svg)](https://codecov.io/gh/brianegan/flutter_stream_friends)

Connect Flutter Widgets to Dart Streams! In Flutter, there's a wonderful distinction between `StatefulWidgets` and `StatelessWidgets`. When used well, `StatefulWidgets` provide a convenient way to encapsulate your data coordination needs in one component, and keep the UI rendering in various "passive" `StatelessWidgets`. In React terms, this is often called the "Smart Component / Dumb Component" pattern, and is similar to the "Active Presenter / Passive View" pattern in MVP.

However, what if you've got slightly more advanced data needs, such as loading
data from a database or web server? Furthermore, you may need to listen to a continuous stream of updates from a Store or EventBus. Finally, you may require more powerful control over your event-handling, such as being able to `debounce` or `buffer` the events passing through an event-handler. For these use cases, Streams provide a great way to manage the events and data needs of a `StatefulWidget`!

In general: what if we could combine the power of `StatefulWidgets` with the elegance of `Streams`? That's just what this library aims to help with.

## How it works

In order to understand the concept, let's compare the default usage of `StatefulWidget` to a `StreamBuilder` version. This library used to provide a `StreamWidget`, but we now recommend using the new `StreamBuilder` widget provided by the Flutter framework. 

### Original
 
Let's start with the simple counter example that comes out of the box when you create a new Flutter app. The important parts are:

  - Create a `StatefulWidget` with a corresponding `State` object
  - Within the `State` object, create widget state and event handlers
  - The event handlers are responsible for updating the local state of the widget
  - Use these pieces of state within the `build` method. 

```dart
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful,
  // meaning that it has a State object (defined below) that contains
  // fields that affect how it looks.

  // This class is the configuration for the state. It holds the
  // values (in this case the title) provided by the parent (in this
  // case the App widget) and used by the build method of the State.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that
      // something has changed in this State, which causes it to rerun
      // the build method below so that the display can reflect the
      // updated values. If we changed _counter without calling
      // setState(), then the build method would not be called again,
      // and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance
    // as done by the _incrementCounter method above.
    // The Flutter framework has been optimized to make rerunning
    // build methods fast, so that you can just rebuild anything that
    // needs updating rather than having to individually change
    // instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that
        // was created by the App.build method, and use it to set
        // our appbar title.
        title: new Text(config.title),
      ),
      body: new Center(
        child: new Text(
          'Button tapped $_counter time${ _counter == 1 ? '' : 's' }.',
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma tells the Dart formatter to use
      // a style that looks nicer for build methods.
    );
  }
}
```

### StreamBuilder version

Now, let's take a look at the version using streams! This code will produce the exact same UI, but the way it manages state is a bit different. Rather than relying on local state within a `State` object, using handlers to `setState`, we use the power of the Dart `Stream` to continually listen to and deliver new information to the Widget in response to button presses!

How it works:

  - Create a Stateless widget that contains a `StreamBuilder`
  - The `StreamBuilder` takes a `stream` parameter. Instead of creating a `State` object to manage the counter state, we'll create a `Stream` instead that will deliver the current count.
  - The `Stream` we build contains a `VoidStreamCallback` that acts as both the `onPressed` handler on the `floatingActionButton` and as the stream we'll listen to so we know when the button is pressed.
  - Then, as the button is pressed, the Stream will deliver the latest value to the 

Now that we've chatted a bit about how it works, let's see the code!

```dart
class MyApp extends StatelessWidget {
  static String appTitle = "Flutter Stream Friends";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new StreamBuilder(
          stream: new CounterScreenStream(appTitle),
          builder: (context, snapshot) => buildHome(
              context,
              snapshot.hasData
                  // If our stream has delivered data, build our Widget properly
                  ? snapshot.data
                  // If not, we pass through a dummy model to kick things off
                  : new CounterScreenModel(0, () {}, appTitle))),
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

class CounterScreenStream extends Stream<CounterScreenModel> {
  final Stream<CounterScreenModel> _stream;

  CounterScreenStream(String title,
      [VoidStreamCallback onFabPressed, int initialValue = 0])
      : this._stream = createStream(
            title, onFabPressed ?? new VoidStreamCallback(), initialValue);

  @override
  StreamSubscription<CounterScreenModel> listen(
          void onData(CounterScreenModel event),
          {Function onError,
          void onDone(),
          bool cancelOnError}) =>
      _stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  // The method we use to create the stream that will continually deliver data
  // to the `buildHome` method.
  static Stream<CounterScreenModel> createStream(
      String title, VoidStreamCallback onFabPressed, int initialValue) {
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
          count == other.count &&
          onFabPressed == other.onFabPressed;

  @override
  int get hashCode => title.hashCode ^ count.hashCode ^ onFabPressed.hashCode;

  @override
  String toString() =>
      'CounterScreenModel{title: $title, count: $count, onFabPressed: $onFabPressed}';
}
```

## Why would you do this madness!?

You might ask: Why would you do this? The second version is so much more code! And you're right, for a super simple example, such as a counter, this is indeed much more code.

However, there are some important advantages: First, separation of concerns. The state logic is now properly encapsulated as a Stream is easily testable. This should not be undervalued.

Second, it makes your state management fundamentally reactive! That means your Widgets can stay up to date with a variety
of data sources that emit state changes (think Firebase or WebSockets or Redux). For example:

  - You may have more complex data needs, such as:
    - calling a local database, file system, or web service when your Widget initializes
    - Keeping your Widgets up to date with a reactive data source, such as a Firebase Database, WebSocket, or Redux Store 
  - No longer make manual calls to `setState`. Just set up your stream and the `StreamWidget` handles the rest.
  - You can use the power of Streams to reduce the number redraws your UI performs. By using `Stream#distinct` under the hood, setState will only be called when data is truly fresh.
  - No need to worry about manually canceling any StreamSubscriptions.  
  - Helpful when you have more advanced event handling needs, such as needing to `debounce` or `buffer` the events.
  
## Examples

You can check out the `example` directory showing the code above implemented as a real Flutter app.

Another project is being worked on that also demonstrates this concept when listening to a Redux store!
