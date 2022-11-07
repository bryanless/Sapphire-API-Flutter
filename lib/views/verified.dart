part of 'pages.dart';

class VerifiedPage extends StatefulWidget {
  const VerifiedPage({super.key});

  static const routeName = '/verified';

  @override
  State<VerifiedPage> createState() => _VerifiedPageState();
}

class _VerifiedPageState extends State<VerifiedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Thank you for verifying",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const VSpacer(space: Space.small),
                  Text(
                    "Your email has been verified",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const VSpacer(space: 64),
                  Lottie.asset(
                    'assets/animations/lottie_verified.json',
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const VSpacer(space: 64),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
