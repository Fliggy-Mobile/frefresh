import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frefresh/frefresh.dart';

void main() {
  Widget buildApp(
      {FRefreshController? controller, FRefreshCallback? onRefresh}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: FRefresh(
              controller: controller,
              header: Container(height: 50, color: Colors.red),
              headerHeight: 50,
              onRefresh: onRefresh,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 50,
                itemBuilder: (_, index) => ListTile(title: Text('item $index')),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('FRefresh builds with a scrollable child', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(find.text('item 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('controller re-binds when FRefresh is recreated (#11)',
      (tester) async {
    final controller = FRefreshController();
    final states = <dynamic>[];
    controller.setOnStateChangedCallback(states.add);

    await tester.pumpWidget(buildApp(controller: controller));
    await tester.pumpAndSettle();
    expect(controller.scrollMetrics, isNotNull);

    // Simulate a tab switch: the old FRefresh is disposed...
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(controller.scrollMetrics, isNull);

    // ...and a new FRefresh binds to the same controller.
    await tester.pumpWidget(buildApp(controller: controller));
    await tester.pumpAndSettle();
    expect(controller.scrollMetrics, isNotNull);

    // The state callback must still work after re-binding. Before the fix,
    // disposing the FRefresh also disposed the controller and wiped its
    // callbacks, so no state was reported any more ("No FRefresh is bound!").
    controller.refresh();
    await tester.pumpAndSettle();
    expect(states, isNotEmpty);
    controller.dispose();
  });

  testWidgets('no exception when viewport size changes (#9)', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Simulate an orientation change by resizing the test surface. Before
    // the fix, the repaint read `child.size` outside of layout and threw
    // "RenderBox.size accessed beyond the scope of resize, layout...".
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
