## 2.0.0

- Null safety support (Dart SDK `>=2.12.0 <4.0.0`)

- Fixed: "RenderBox.size accessed beyond the scope of resize, layout..." when the device orientation changes (#9)

- Fixed: "No FRefresh is bound!" after switching tabs (#11). FRefresh no longer disposes the `FRefreshController` passed to it — the controller is only unbound when the bound FRefresh is disposed, and re-binds automatically when a new FRefresh is created. Owners should dispose the controller themselves when it is no longer needed

- Breaking: `FRefreshController.scrollMetrics` now returns `ScrollMetrics?`

## 1.1.1

- `onRefresh` and `onLoad` can return any value to stop refreshing automatically, without going through FRefreshController. E.g:

```dart
FRefresh(
  ...,

  onRefresh: () async {
    await Future(duration: Duration(milliseconds: 3000));

    /// Actively stop refreshing
    return true;
  },

  onLoad: () async {
    await Future(duration: Duration(milliseconds: 3000));
  
    /// Actively stop loading
    return true;
  }
)
```

- Eliminate the adverse effects of horizontal sliding

## 1.1.0

- FRefreshController added control function
    `scrollTo(double position, {Duration duration = const Duration(milliseconds: 300)})`
    `scrollBy(double position, {Duration duration = const Duration(milliseconds: 300)})`
    `jumpTo(double postion)`

- FRefreshController adds `double position`,` ScrollMetrics scrollMetrics` and other parameters to get sliding information

- FRefreshController adds a useful parameter `backOriginOnLoadFinish`. When loading is completed, whether to return to the original position. For example, when the GridView adds only one element, this parameter is useful.

## 1.0.0

- the first version
