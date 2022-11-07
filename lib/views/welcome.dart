part of 'pages.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static const String routeName = '/welcome';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          minimum: const EdgeInsets.all(16),
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const VSpacer(
                    space: 120,
                  ),
                  Text(
                    "Hi there, what should we call you?",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const VSpacer(space: 64),
                  SvgPicture.asset(
                    '${Const.imagePath}/undraw_personal_info.svg',
                    height: 150,
                  ),
                  const VSpacer(space: 64),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        OutlinedTextField(
                          controller: nameController,
                          prefixIcon: SapphireIcons.badge,
                          labelText: 'Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ],
                    ),
                  ),
                  const VSpacer(space: Space.large),
                  FilledButton(
                    label: 'Next',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(
                          context,
                          HomePage.routeName,
                          arguments: HomePageArguments(nameController.text),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
