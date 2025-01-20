import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munch/helpers/helper_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('FoodLoader shows loading image', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FoodLoader(),
        ),
      ),
    );
    expect(find.byType(Image), findsOneWidget);
    final Image image = tester.widget(find.byType(Image));
    expect(image.image, isInstanceOf<AssetImage>());
    expect((image.image as AssetImage).assetName, 'assets/images/onebanc_logo.jpeg');
  });

  testWidgets('FoodLoader rotation animation plays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FoodLoader(),
        ),
      ),
    );
    final rotationTransition = find.byType(RotationTransition);
    expect(rotationTransition, findsOneWidget);
    final RotationTransition rotationWidget = tester.widget(rotationTransition);
    expect(rotationWidget.turns.value, 0.0);
    await tester.pump(const Duration(milliseconds: 500));
    expect(rotationWidget.turns.value, greaterThan(0.0));
    await tester.pump(const Duration(milliseconds: 500));
    expect(rotationWidget.turns.value, 0.0);
  });

  testWidgets('FoodLoader stops animation when disposed', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FoodLoader(),
        ),
      ),
    );
    expect(find.byType(FoodLoader), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(find.byType(FoodLoader), findsNothing);
  });
}
