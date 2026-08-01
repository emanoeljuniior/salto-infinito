import 'package:flutter_test/flutter_test.dart';

import 'package:salto_infinito/main.dart';

void main() {
  testWidgets('Home screen exibe título e botão Jogar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SaltoInfinitoApp());
    await tester.pumpAndSettle();

    expect(find.text('Salto Infinito'), findsOneWidget);
    expect(find.text('Jogar'), findsOneWidget);
  });
}
