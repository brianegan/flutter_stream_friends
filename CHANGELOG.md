# Changelog

## 0.8.0

  * Support Dart 2

## 0.7.0

  * Automatically closes the `streamCotroller` when all subscriptions to a StreamCallback are cancelled
  * Add `InfiniteScrollStream`. Emits events when a list is scrolled to the end so you can fetch more data!

## 0.6.2

  * Add `RefreshStreamCallback`

## 0.6.1

  * Move to github

## 0.6.0

  * Updated the lib for compatibility with the latest version of Flutter 

## 0.5.0

  * Updated the lib for compatibility with the latest version of Flutter 

## 0.1.0

Initial version. This introduces the concept of a`StreamWidget`. This is a `StatefulWidget` that manages its state using streams rather than manual calls to `setState` within a `State` object. Also includes a number of `StreamCallbacks`. These are a special type of class that act as both an event handler and a Stream. Simply pass the `StreamCallback` as an event-hanler for a given event, such as `onTap`, and then `listen` to the `StreamCallback` for any time the `Widget` is tapped.

The following Flutter Callbacks are covered by `StreamCallbacks`:

  - `VoidCallback`
  - `GestureDragDownCallback`
  - `GestureDragStartCallback`
  - `GestureDragUpdateCallback`
  - `GestureDragEndCallback`
  - `GestureDragCancelCallback`
  - `GestureLongPressCallback`
  - `GestureMultiTapDownCallback`
  - `GestureMultiTapUpCallback`
  - `GestureMultiTapCallback`
  - `GestureMultiTapCancelCallback`
  - `GestureMultiTapDownCallback`
  - `GestureMultiTapUpCallback`
  - `GestureScaleStartCallback`
  - `GestureScaleUpdateCallback`
  - `GestureScaleEndCallback`
  - `GestureTapDownCallback`
  - `GestureTapUpCallback`
  - `GestureTapCallback`
  - `GestureTapCancelCallback`
  - `DismissDirectionCallback`
  - `DraggableCanceledCallback`
