import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('Shows Tic Tac Toe title and board', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // App title in AppBar
    expect(find.text('Tic Tac Toe'), findsWidgets);

    // Status shows current player and the knight semantic for X.
    expect(find.bySemanticsLabel('Knight'), findsWidgets);

    // There should be 9 tappable cells (InkWell inside _Cell)
    expect(find.byType(InkWell), findsNWidgets(9));
  });

  testWidgets('Tapping alternates players and detects win; ignores taps after game over', (tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Tap sequence to make X (Knight) win on first row: positions 0,1,2 interleaved with O (Queen).
    final cells = find.byType(InkWell);
    await tester.tap(cells.at(0)); // Knight
    await tester.pumpAndSettle();
    await tester.tap(cells.at(3)); // Queen
    await tester.pumpAndSettle();
    await tester.tap(cells.at(1)); // Knight
    await tester.pumpAndSettle();
    await tester.tap(cells.at(4)); // Queen
    await tester.pumpAndSettle();
    await tester.tap(cells.at(2)); // Knight wins
    await tester.pumpAndSettle();

    // Winner label should show and contain the knight semantic/icon.
    expect(find.textContaining('Winner:'), findsOneWidget);
    expect(find.bySemanticsLabel('Knight'), findsWidgets);

    // Taps after game over should be ignored (no state change that removes the winner).
    await tester.tap(cells.at(8));
    await tester.pumpAndSettle();
    expect(find.textContaining('Winner:'), findsOneWidget);
  });
}
