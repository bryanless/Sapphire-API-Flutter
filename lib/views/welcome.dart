part of 'pages.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static const String routeName = '/welcome';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _initialURILinkHandled = false;
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  StreamSubscription? _streamSubscription;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  bool _isNextActive = false;

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
        setState(() {
          _currentURI = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  void _changeNextButtonState() {
    setState(
      () {
        _isNextActive = _nameController.text.isNotEmpty;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
    _nameController.addListener(_changeNextButtonState);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

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
                          controller: _nameController,
                          prefixIcon: SapphireIcons.badge,
                          labelText: 'Name',
                          textCapitalization: TextCapitalization.words,
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
                    onPressed: _isNextActive
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushNamed(
                                context,
                                EmailPage.routeName,
                                arguments:
                                    EmailPageArguments(_nameController.text),
                              );
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const EmailPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
