import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munch/helpers/snackbar_bottom.dart';

void main() {
  testWidgets('showCustomSnackbar displays a Snackbar with the correct message', (WidgetTester tester) async {
    final testWidget = MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showCustomSnackbar(tester.element(find.byType(ElevatedButton)), text: 'Test Snackbar');
            },
            child: const Text('Show Snackbar'),
          ),
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    final snackbarFinder = find.byType(SnackBar);
    final snackBar = tester.widget<SnackBar>(snackbarFinder);
    expect(snackBar.content, isA<SizedBox>());
    final card = (snackBar.content as SizedBox).child as Card;
    final textWidget = (card.child as Row).children[1] as Text;
    expect(textWidget.data, 'Test Snackbar');
    expect(textWidget.style?.color, const Color.fromARGB(255, 22, 114, 25));
    await tester.pumpAndSettle(const Duration(milliseconds: 1200));
    expect(find.byType(SnackBar), findsOne);
  });
}
