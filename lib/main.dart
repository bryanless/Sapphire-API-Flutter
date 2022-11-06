import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:sapphire_api_flutter/theme/theme.dart';
import 'package:sapphire_api_flutter/views/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Sapphire API',
          theme: DynamicTheme.lightTheme(lightColorScheme),
          darkTheme: DynamicTheme.darkTheme(darkColorScheme),
          home: const HomePage(),
        );
      },
    );
  }
}
