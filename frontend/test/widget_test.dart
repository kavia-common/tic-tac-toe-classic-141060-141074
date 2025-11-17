import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('Shows Tic Tac Toe title and board', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // App title
    expect(find.text('Tic Tac Toe'), findsOneWidget);

    // Status text
    expect(find.textContaining('Current Player:'), findsOneWidget);

    // There should be 9 tappable cells (by GestureDetector via _Cell)
    // We look for 9 containers inside grid
    expect(find.byType(GestureDetector), findsNWidgets(9));
  });

  testWidgets('Tapping alternates X and O and detects win/draw ignore invalid taps', (tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Tap sequence to make X win on first row: positions 0,1,2 interleaved with O.
    final cells = find.byType(GestureDetector);
    await tester.tap(cells.at(0)); // X
    await tester.pumpAndSettle();
    await tester.tap(cells.at(3)); // O
    await tester.pumpAndSettle();
    await tester.tap(cells.at(1)); // X
    await tester.pumpAndSettle();
    await tester.tap(cells.at(4)); // O
    await tester.pumpAndSettle();
    await tester.tap(cells.at(2)); // X wins
    await tester.pumpAndSettle();

    expect(find.textContaining('Winner: X'), findsOneWidget);

    // Taps after game over should be ignored (no exception should occur)
    await tester.tap(cells.at(8));
    await tester.pumpAndSettle();
    expect(find.textContaining('Winner: X'), findsOneWidget);
  });
}
