import 'package:festpass/core/data/seed_events.dart';
import 'package:festpass/core/models/event.dart';
import 'package:festpass/shared/widgets/event_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('evento mantém os dados ao converter para o Firebase', () {
    final original = seedEvents.first;
    final restored = EventData.fromMap(original.toMap());

    expect(restored.id, original.id);
    expect(restored.lotes, original.lotes);
    expect(restored.lotesPrices, original.lotesPrices);
    expect(restored.category, original.category);
  });

  testWidgets('banner cria uma figura própria para o evento', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: EventBanner(colorIndex: 0, height: 120)),
      ),
    );

    expect(find.text('T'), findsNWidgets(3));
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
