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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(child: Text("Verified")),
          ],
        ),
      ),
    );
  }
}
