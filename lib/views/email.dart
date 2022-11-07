part of 'pages.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  static const routeName = '/email';

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  bool _isEmailSent = false;
  bool _isSendActive = false;

  bool _responseStatus = false;
  String _responseError = "";

  void _checkSendStatus() {
    String value = emailController.text;
    _changeEmailSent(false);
    if (value.isEmpty || !EmailValidator.validate(value.toString())) {
      _changeSendButtonState(false);
    } else {
      _changeSendButtonState(true);
    }
  }

  void _changeSendButtonState(bool isSendActive) {
    setState(() {
      _isSendActive = isSendActive;
    });
  }

  void _changeEmailSent(bool isEmailSent) {
    setState(() {
      _isEmailSent = isEmailSent;
    });
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkSendStatus);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EmailPageArguments;

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
                  onPressed: _isSendActive
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sending your email'),
                              ),
                            );
                            // Disable button
                            _changeSendButtonState(false);
                            // Send mail
                            await SapphireService.sendMail(
                              emailController.text,
                              args.name,
                            ).then((value) {
                              var result = jsonDecode(value.body);
                              _responseStatus = result['status'];
                              if (!_responseStatus) {
                                _responseError = result['error'];
                              }
                            }).catchError((error) {
                              debugPrint(error.toString());
                            });
                            if (!mounted) return;
                            // Change button state
                            _changeSendButtonState(_responseStatus);
                            _changeEmailSent(_responseStatus);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: _responseStatus
                                      ? const Text(
                                          "Verification email has been sent")
                                      : Text(_responseError),
                                  action: SnackBarAction(
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      label: 'Dismiss',
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      }),
                                ),
                              );
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailPageArguments {
  final String name;

  EmailPageArguments(this.name);
}
