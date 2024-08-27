import 'package:animate_do/animate_do.dart';
import 'package:family_tree/UI_Presentation/Navigation/stepper.dart';
import 'package:flutter/material.dart';

class WelcomeSplashScreen extends StatelessWidget {
  final Duration duration = const Duration(milliseconds: 500);

  const WelcomeSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        margin: const EdgeInsets.all(8),
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ///
            FadeInUp(
              duration: duration,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 50,
                  left: 5,
                  right: 5,
                ),
                width: size.width,
                height: size.height / 2,
                child: const Icon(Icons.account_tree),
              ),
            ),

            ///
            const SizedBox(
              height: 15,
            ),

            /// TITLE
            FadeInUp(
              duration: duration,
              child: const Text(
                "Family Tree",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),

            ///
            const SizedBox(
              height: 10,
            ),

            /// SUBTITLE
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 200),
              child: const Text(
                "The Family Tree Graph.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.2, color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w300),
              ),
            ),

            ///
            Expanded(child: Container()),

            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 1000),
              child: SButton(
                size: size,
                color: Theme.of(context).colorScheme.primary,
                text: 'Get started',
                textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EZ_Stepper(),
                  ),
                ),
              ),
            ),

            // /// GOOGLE BTN
            // FadeInUp(
            //   duration: duration,
            //   delay: const Duration(milliseconds: 1000),
            //   child: Column(
            //     children: [
            //       SButton(
            //         size: size,
            //         color: Theme.of(context).colorScheme.primary,
            //         text: "Register",
            //         textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            //         onPressed: () => Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => const Register(),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 20,
            //       ),
            //       SButton(
            //         size: size,
            //         color: Theme.of(context).colorScheme.primaryContainer,
            //         text: "Login",
            //         textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
            //         onPressed: () => Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => const Login(),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            ///
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class SButton extends StatelessWidget {
  const SButton(
      {super.key,
      required this.size,
      required this.color,
      required this.text,
      required this.textStyle,
      required this.onPressed});

  final Size size;
  final Color color;
  final String text;
  final TextStyle? textStyle;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed();
      },
      child: Container(
        width: size.width / 1.2,
        height: size.height / 15,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
