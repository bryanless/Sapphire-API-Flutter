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

          // Navigate to page
          Navigator.pushNamed(context, VerifiedPage.routeName);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sapphire'),
      ),
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!EmailValidator.validate(value.toString())) {
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sending your email'),
              ),
            );
            await SapphireService.sendMail(emailController.text).then((value) {
              var result = jsonDecode(value.body);
              responseStatus = result['status'];
              if (!responseStatus) {
                responseError = result['error'];
              }
            }).catchError((error) {
              print(error);
            });
            if (!mounted) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: responseStatus
                      ? const Text("Email has been sent")
                      : Text(responseError),
                  action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      }),
                ),
              );
          }
        },
        child: const Icon(Icons.send_rounded),
      ),
    );
  }
}
