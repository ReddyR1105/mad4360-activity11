import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haunted_registry/main.dart';

// Opt-in reproducible captures of actual Flutter rendering, not emulator images.
void main() {
  testWidgets('capture real widget-rendered navigation evidence', (t) async {
    final fontPath = Platform.environment['EVIDENCE_FONT'];
    if (fontPath == null) return;
    final loader = FontLoader('Roboto')
      ..addFont(
        Future.value(ByteData.sublistView(File(fontPath).readAsBytesSync())),
      );
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    t.view.physicalSize = const Size(430, 932);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final boundary = GlobalKey();
    await t.pumpWidget(
      RepaintBoundary(key: boundary, child: const HauntedMansionApp()),
    );
    Future<void> capture(String name) async {
      await t.pump();
      await t.runAsync(() async {
        final image =
            await (boundary.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary)
                .toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('evidence/screenshots/$name.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }

    Future<void> tap(Finder finder) async {
      await t.ensureVisible(finder);
      await t.tap(finder);
      await t.pumpAndSettle();
    }

    await t.pumpAndSettle();
    await capture('widget-01-welcome');
    await tap(find.text('Enter If You Dare'));
    await t.enterText(find.byKey(const Key('name')), 'Demo Het');
    await t.enterText(find.byKey(const Key('email')), 'demo@example.com');
    await t.enterText(find.byKey(const Key('password')), 'secret123');
    await tap(find.byKey(const Key('birthday')));
    await tap(find.text('OK'));
    await tap(find.byKey(const Key('creature')));
    await tap(find.text('Ghost').last);
    await capture('widget-02-filled-form');
    await t.ensureVisible(find.byKey(const Key('submit')));
    await t.tap(find.byKey(const Key('submit')));
    await t.pump();
    await capture('widget-03-loading');
    await t.pump(const Duration(seconds: 2));
    await t.pump(const Duration(seconds: 1));
    await t.pump();
    expect(find.text('Welcome, Demo Het!'), findsOneWidget);
    await capture('widget-04-success');
    await t.pageBack();
    await t.pumpAndSettle();
    expect(find.text('Enter If You Dare'), findsOneWidget);
    await capture('widget-05-back-to-foyer');
  }, skip: Platform.environment['EVIDENCE_FONT'] == null);
}
