import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haunted_registry/main.dart';

Future<void> capture(WidgetTester tester, GlobalKey key, String name) async {
  await tester.pump(const Duration(seconds: 1));
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    Directory('evidence').createSync(recursive: true);
    File('evidence/$name.png').writeAsBytesSync(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  testWidgets('capture real rendered app and exercise five picker boundaries', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final config =
          jsonDecode(File('.dart_tool/package_config.json').readAsStringSync())
              as Map<String, dynamic>;
      final package = (config['packages'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .firstWhere((p) => p['name'] == 'flutter');
      final configUri = File('.dart_tool/package_config.json').absolute.uri;
      final sdk = Directory.fromUri(
        configUri.resolve(package['rootUri'] as String),
      ).parent.parent.path;
      final font = FontLoader('Roboto');
      font.addFont(
        Future.value(
          ByteData.sublistView(
            File(
              '$sdk/bin/cache/artifacts/material_fonts/roboto-regular.ttf',
            ).readAsBytesSync(),
          ),
        ),
      );
      await font.load();
      final icons = FontLoader('MaterialIcons');
      icons.addFont(
        Future.value(
          ByteData.sublistView(
            File(
              '$sdk/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
            ).readAsBytesSync(),
          ),
        ),
      );
      await icons.load();
    });
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boundary = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(key: boundary, child: const HauntedMansionApp()),
    );
    await tester.pumpAndSettle();
    await capture(tester, boundary, '01-foyer');
    await tester.tap(find.text('Enter If You Dare'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('name')), 'Rohan');
    await tester.enterText(find.byKey(const Key('password')), 'abc123');
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    await capture(tester, boundary, '02-signup');
    final now = DateUtils.dateOnly(DateTime.now());
    final cases = <(DateTime, bool)>[
      (DateTime(1920), true),
      (DateTime(2008), true),
      (now, true),
      (now.add(const Duration(days: 1)), false),
      (DateTime(1919, 12, 31), false),
    ];
    final results = <String>['Input | Expected | Observed'];
    for (var i = 0; i < cases.length; i++) {
      final (date, valid) = cases[i];
      await tester.tap(find.byKey(const Key('birthday')));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Switch to input'));
      await tester.pumpAndSettle();
      final input = find.descendant(
        of: find.byType(DatePickerDialog),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(input, '${date.month}/${date.day}/${date.year}');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(
        find.byType(DatePickerDialog),
        valid ? findsNothing : findsOneWidget,
      );
      await capture(tester, boundary, 'date-${i + 1}');
      results.add(
        '${date.toIso8601String().split('T').first} | ${valid ? 'Accept' : 'Reject'} | ${valid ? 'Accepted' : 'Rejected with inline error'}',
      );
      if (!valid) {
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      }
    }
    await tester.tap(find.byKey(const Key('birthday')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Switch to input'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(DatePickerDialog),
        matching: find.byType(TextFormField),
      ),
      '1/1/2008',
    );
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('creature')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ghost').last);
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(1200, 800);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('name')))
          .controller!
          .text,
      'Rohan',
    );
    await capture(tester, boundary, '03-landscape');
    await tester.runAsync(
      () async => File(
        'evidence/date-results.txt',
      ).writeAsStringSync(results.join('\n')),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
