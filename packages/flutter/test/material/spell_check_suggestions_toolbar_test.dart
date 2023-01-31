// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Vertical position at which to anchor the toolbar for testing.
const double _kAnchor = 200;
// Amount for toolbar to overlap bottom padding for testing.
const double _kTestToolbarOverlap = 10;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Builds test button items for each of the suggestions provided.
  List<ContextMenuButtonItem> buildSuggestionButtons(List<String> suggestions) {
    final List<ContextMenuButtonItem> buttonItems = <ContextMenuButtonItem>[];

    for (final String suggestion in suggestions) {
      buttonItems.add(ContextMenuButtonItem(
        onPressed: () {},
        label: suggestion,
      ));
    }

    final ContextMenuButtonItem deleteButton =
      ContextMenuButtonItem(
        onPressed: () {},
        type: ContextMenuButtonType.delete,
        label: 'DELETE',
    );
    buttonItems.add(deleteButton);

    return buttonItems;
  }

  /// Finds the container of the [SpellCheckSuggestionsToolbar] so that
  /// the position of the toolbar itself may be determined.
  Finder findSpellCheckSuggestionsToolbar() {
    return find.descendant(
      of: find.byType(MaterialApp),
      matching: find.byWidgetPredicate(
        (Widget w) => '${w.runtimeType}' == '_SpellCheckSuggestionsToolbarContainer'),
    );
  }

  testWidgets('positions toolbar below anchor when it fits above bottom view padding', (WidgetTester tester) async {
    // We expect the toolbar to be positioned right below the anchor with padding accounted for.
    const double expectedToolbarY =
        _kAnchor + (2 * SpellCheckSuggestionsToolbar.kToolbarContentDistanceBelow) - TextSelectionToolbar.kToolbarScreenPadding;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SpellCheckSuggestionsToolbar(
            anchor: const Offset(0.0, _kAnchor),
            buttonItems: buildSuggestionButtons(<String>['hello', 'yellow', 'yell']),
          ),
        ),
      ),
    );

    final double toolbarY = tester.getTopLeft(findSpellCheckSuggestionsToolbar()).dy;
    expect(toolbarY, equals(expectedToolbarY));
  });

  testWidgets('re-positions toolbar higher below anchor when it does not fit above bottom view padding', (WidgetTester tester) async {
    // We expect the toolbar to be positioned _kTestToolbarOverlap pixels above the anchor with padding accounted for.
    const double expectedToolbarY =
        _kAnchor + (2 * SpellCheckSuggestionsToolbar.kToolbarContentDistanceBelow) - TextSelectionToolbar.kToolbarScreenPadding - _kTestToolbarOverlap;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SpellCheckSuggestionsToolbar(
            anchor: const Offset(0.0, _kAnchor - _kTestToolbarOverlap),
            buttonItems: buildSuggestionButtons(<String>['hello', 'yellow', 'yell']),
          ),
        ),
      ),
    );

    final double toolbarY = tester.getTopLeft(findSpellCheckSuggestionsToolbar()).dy;
    expect(toolbarY, equals(expectedToolbarY));
  });
}
