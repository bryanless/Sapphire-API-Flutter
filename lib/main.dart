import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sapphire_api_flutter/theme/theme.dart';
import 'package:sapphire_api_flutter/views/pages.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const SapphireApiApp());
}

class SapphireApiApp extends StatelessWidget {
  const SapphireApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Sapphire API',
          theme: DynamicTheme.lightTheme(lightColorScheme),
          darkTheme: DynamicTheme.darkTheme(darkColorScheme),
          home: const WelcomePage(),
          routes: {
            WelcomePage.routeName: (context) => const WelcomePage(),
            VerifiedPage.routeName: (context) => const VerifiedPage(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case HomePage.routeName:
                return PageTransition(
                  child: const HomePage(),
                  type: PageTransitionType.rightToLeftJoined,
                  childCurrent: this,
                  settings: settings,
                );
              default:
                return null;
            }
          },
        );
      },
    );
  }
}
