import 'package:flutter/material.dart';

import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:woju/firebase_options.dart';
import 'package:woju/model/hive_box_enum.dart';
import 'package:woju/provider/go_route_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  for (var box in HiveBox.values) {
    box.registerAdapter();
    await box.openBox();
  }

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ko', 'KR'),
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      builder: (context, child) => AccessibilityTools(child: child),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      darkTheme: ThemeData.dark(useMaterial3: false),
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      routerConfig: ref.watch(goRouterProvider),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
