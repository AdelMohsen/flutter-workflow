// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/core/ui/adaptive/adaptive_widgets.dart';
import '../lib/core/ui/app_content.dart';

void main() {
  testWidgets('uses Cupertino button on iOS', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: AdaptiveButton(label: 'Continue', onPressed: () {}),
      ),
    );
    expect(find.byType(CupertinoButton), findsOneWidget);
  });

  testWidgets('uses Material button on Android', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: AdaptiveButton(label: 'Continue', onPressed: () {}),
      ),
    );
    expect(
      find.byWidgetPredicate((widget) => widget is FilledButton),
      findsOneWidget,
    );
  });

  testWidgets('caps tablet content at 720 pixels', (tester) async {
    tester.view.physicalSize = const Size(1024, 1366);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const childKey = Key('content');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppContent(
            padding: EdgeInsets.zero,
            child: SizedBox(key: childKey, width: double.infinity, height: 20),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byKey(childKey)).width, 720);
  });
}
