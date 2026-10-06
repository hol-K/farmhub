import 'package:flutter/material.dart';
import 'package:farmhub/features/producer/widgets/sync_badge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('affiche les statuts de synchronisation attendus', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: Column(
          children: [SyncBadge(pending: true), SyncBadge(pending: false)],
        ),
      ),
    );

    expect(find.text("En attente d'envoi"), findsOneWidget);
    expect(find.text('Publié'), findsOneWidget);
  });

  testWidgets('« Vendu » remplace « Publié », l\'attente d\'envoi reste prioritaire', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: Column(
          children: [
            SyncBadge(pending: false, sold: true),
            SyncBadge(pending: true, sold: true),
          ],
        ),
      ),
    );

    expect(find.text('Vendu'), findsOneWidget);
    expect(find.text("En attente d'envoi"), findsOneWidget);
    expect(find.text('Publié'), findsNothing);
  });

  testWidgets('affiche le bandeau hors-ligne', (tester) async {
    await tester.pumpWidget(const _TestApp(child: OfflineBanner()));

    expect(find.text('Hors-ligne'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: Scaffold(body: child));
}
