import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Home/HomeCubit/home_cubit.dart';
import '../Home/home_page.dart';
import 'LoginRegisterCubits/authentication_cubit.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showSpinner = false;
  bool _obscurePW = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController unController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pw2Controller = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController familyCodeController = TextEditingController();
  bool saveUnPw = false;

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
              current is AuthenticationFailureState ||
              current is AuthenticationRegistrationFailureState ||
              current is AuthenticationRegistrationFailureEmailState ||
              current is AuthenticationRegistrationFailurePassState ||
              current is AuthenticationRegistrationFailureFamilyState;
        }, listener: (context, state) {
          if (state is AuthenticationLoadingState) {
            setState(() {
              showSpinner = true;
            });
          } else if (state is AuthenticationRegistrationFailureEmailState) {
            setState(() {
              showSpinner = false;
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const Text('Registration failure'),
                content: const Text('This email already exists. Go to login?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No'),
                  )
                ],
              ),
            );
          } else if (state is AuthenticationRegistrationFailurePassState) {
            setState(() {
              showSpinner = false;
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const Text('Registration failure'),
                content: const Text('Please pick a stronger password'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok'))
                ],
              ),
            );
          } else if (state is AuthenticationRegistrationFailureState) {
            setState(() {
              showSpinner = false;
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const Text('Registration failure'),
                content: const Text('An error occurred with Registration'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok'))
                ],
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
                content: const Text(
                    'An error occurred with Login. Go to login page to try again'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    ),
                    child: const Text('Ok'),
                  )
                ],
              ),
            );
          } else if (state is AuthenticationRegistrationFailureFamilyState) {
            setState(() {
              showSpinner = false;
            });
            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const Text('Register failure'),
                content: const Text('A family with this code doesn\'t exist'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok'),
                  )
                ],
              ),
            );
          } else if (state is AuthenticationSuccessState) {
            pwController.clear();
            pw2Controller.clear();
            setState(() {
              showSpinner = false;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider<HomeCubit>(
                  create: (BuildContext context) => HomeCubit(),
                  child: const HomePage(),
                ),
              ),
            );
          }
        }, builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: buildRegisterPage(context, currentFocus),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildRegisterPage(BuildContext context, currentFocus) {
    return Form(
      key: _formKey,
      child: Container(
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
            const Spacer(),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: pw2Controller,
              obscureText: _obscurePW,
              decoration:
                  decor('Enter your password again', currentFocus, true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '*required';
                } else if (value != pwController.text) {
                  return 'Passwords must be the same';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              onEditingComplete: () => currentFocus.nextFocus(),
            ),
            const Spacer(),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: fNameController,
              decoration: decor('Enter your first name', currentFocus, false),
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
              controller: lNameController,
              decoration: decor('Enter your last name', currentFocus, false),
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
              controller: familyCodeController,
              decoration: decor('Enter your family code (blank for new family)',
                  currentFocus, false),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => currentFocus.nextFocus(),
            ),
            const Spacer(flex: 4),
            TextButton(
              child: const Text('Register'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<AuthenticationCubit>(context).registerUser(
                      unController.text,
                      pwController.text,
                      fNameController.text,
                      lNameController.text,
                      familyCodeController.text);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Registration Failed'),
                      content:
                          const Text('Please fill out all required fields'),
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
            ),
            const Spacer(),
            const Spacer(flex: 9),
          ],
        ),
      ),
    );
  }
}
