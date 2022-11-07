part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _initialURILinkHandled = false;
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  StreamSubscription? _streamSubscription;

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  bool _isEmailSent = false;

  late bool responseStatus;
  late String responseError;

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

  void changeEmailSent(bool isEmailSent) {
    setState(() {
      _isEmailSent = isEmailSent;
    });
  }

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
  }

  @override
  void dispose() {
    emailController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as HomePageArguments;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const VSpacer(
                  space: 120,
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                    children: <TextSpan>[
                      const TextSpan(text: 'Hi '),
                      TextSpan(
                          text: args.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ", let's verify your email address"),
                    ],
                  ),
                ),
                const VSpacer(space: 64),
                AnimatedCrossFade(
                  crossFadeState: _isEmailSent
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  firstCurve: Curves.easeOut,
                  secondCurve: Curves.easeIn,
                  sizeCurve: Curves.bounceInOut,
                  firstChild: SvgPicture.asset(
                    '${Const.imagePath}/undraw_mailbox.svg',
                    height: 150,
                  ),
                  secondChild: SvgPicture.asset(
                    '${Const.imagePath}/undraw_mail_sent.svg',
                    height: 150,
                  ),
                ),
                const VSpacer(space: 64),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      OutlinedTextField(
                        controller: emailController,
                        labelText: 'Email',
                        prefixIcon: SapphireIcons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          } else if (!EmailValidator.validate(
                              value.toString())) {
                            return 'Please enter a valid email address';
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
                  label: 'Send verification email',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sending your email'),
                        ),
                      );
                      await SapphireService.sendMail(emailController.text)
                          .then((value) {
                        var result = jsonDecode(value.body);
                        responseStatus = result['status'];
                        if (!responseStatus) {
                          responseError = result['error'];
                        }
                      }).catchError((error) {
                        print(error);
                      });
                      if (!mounted) return;
                      changeEmailSent(true);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: responseStatus
                                ? const Text("Verification email has been sent")
                                : Text(responseError),
                            action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                }),
                          ),
                        );
                    }
                  },
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, VerifiedPage.routeName);
                  },
                  label: 'hola',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePageArguments {
  final String name;

  HomePageArguments(this.name);
}
