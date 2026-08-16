import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/main.dart';

void main() {
  testWidgets('Inventory App loads main screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InventoryApp(),
      ),
    );

    expect(find.text('StockMaster Pro'), findsWidgets);
  });
}
