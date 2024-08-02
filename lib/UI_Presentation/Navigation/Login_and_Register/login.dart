import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Home/home_page.dart';
import 'LoginRegisterCubits/authentication_cubit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showSpinner = false;
  bool _obscurePW = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController unController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  InputDecoration decor(String labelText, FocusScopeNode focusNode, bool pw) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      labelText: labelText,
      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      suffixIcon: pw
          ? IconButton(
              onPressed: () {
                setState(() {
                  _obscurePW = !_obscurePW;
                });
              },
              icon: _obscurePW
                  ? const Icon(Icons.remove_red_eye)
                  : const Icon(Icons.remove_red_eye_outlined),
              color: _obscurePW
                  ? Theme.of(context).colorScheme.surfaceTint
                  : Theme.of(context).colorScheme.outlineVariant,
              splashRadius: .01,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFocus = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
            listenWhen: (previous, current) {
          return current is AuthenticationLoadingState ||
              current is AuthenticationSuccessState ||
              current is AuthenticationFailureState;
        }, listener: (context, state) async {
          if (state is AuthenticationLoadingState) {
            setState(() {
              showSpinner = true;
            });
          } else if (state is AuthenticationSuccessState) {
            setState(() {
              showSpinner = false;
            });
            pwController.clear();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (state is AuthenticationFailureState) {
            setState(() {
              showSpinner = false;
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const Text('Login failure'),
                content:
                    const Text('Email or password incorrect. Please try again'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok'),
                  )
                ],
              ),
            );
          }
        }, builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                    key: _formKey,
                    child: buildLoginPage(context, currentFocus, false)),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildLoginPage(BuildContext context, currentFocus, bool failed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: <Widget>[
          const Spacer(flex: 3),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: unController,
            decoration: decor('Enter your email', currentFocus, false),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '*required';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => currentFocus.nextFocus(),
          ),
          const Spacer(),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: pwController,
            obscureText: _obscurePW,
            decoration: decor('Enter your password', currentFocus, true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '*required';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => currentFocus.nextFocus(),
          ),
          const Spacer(flex: 4),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<AuthenticationCubit>(context)
                    .loginUser(unController.text, pwController.text);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Login Failed'),
                    content:
                        const Text('Please enter username and/or password'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Ok'),
                        child: const Text('Ok'),
                      )
                    ],
                  ),
                );
              }
            },
            child: const Text('Login'),
          ),
          const Spacer(),
          failed
              ? const Text(
                  'Username or password is incorrect. Please try again')
              : const Text(''),
          const Spacer(flex: 9),
        ],
      ),
    );
  }
}
