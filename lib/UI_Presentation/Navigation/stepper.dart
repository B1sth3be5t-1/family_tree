import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EZ_Stepper extends StatefulWidget {
  const EZ_Stepper({Key? key}) : super(key: key);

  @override
  State<EZ_Stepper> createState() => _EZ_StepperState();
}

class _EZ_StepperState extends State<EZ_Stepper> {
  int activeStep = 0;
  int upperBound = 3;
  int maxReachedStep = 0;
  double progress = 0.0;
  double newProgress = 0.0;
  bool isLogin = false;

  TextEditingController tecFName = TextEditingController();
  TextEditingController tecLName = TextEditingController();
  TextEditingController tecCode = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPass1 = TextEditingController();
  TextEditingController tecPass2 = TextEditingController();

  void setProgress() {
    setState(() => progress = newProgress);
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage = const Text('');
    if (activeStep == 0) {
      currentPage = Column(
        children: [
          const Text('Welcome to Family Tree!'),
          const Text('Click a button below to begin!'),
          const Divider(),
          TextButton(
              onPressed: () {
                setState(() {
                  isLogin = true;
                  _nextStep();
                });
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () {
                setState(() {
                  isLogin = false;
                  _nextStep();
                });
              },
              child: const Text('Register')),
        ],
      );
    } else if (activeStep == 1) {
      currentPage = TextButton(
        onPressed: () => _nextStep(),
        child: Text('next'),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          currentPage,
          const Spacer(),
          EasyStepper(
            activeStep: activeStep,
            maxReachedStep: maxReachedStep,
            lineStyle: LineStyle(
              lineLength: 50,
              lineThickness: 6,
              lineSpace: 2,
              lineType: LineType.normal,
              defaultLineColor: Colors.purple.shade300,
              progress: progress,
              // progressColor: Colors.purple.shade700,
            ),
            stepAnimationDuration: const Duration(milliseconds: 500),
            borderThickness: 10,
            internalPadding: 15,
            steps: [
              const EasyStep(
                icon: Icon(CupertinoIcons.person_circle),
                finishIcon: Icon(CupertinoIcons.person_circle_fill),
                title: 'Start',
                lineText: 'Login/Register',
              ),
              EasyStep(
                enabled: !isLogin && maxReachedStep >= 1,
                icon: const Icon(CupertinoIcons.info),
                finishIcon: const Icon(CupertinoIcons.info_circle_fill),
                title: 'Details',
                lineText: 'Enter details',
              ),
              EasyStep(
                enabled: !isLogin && maxReachedStep >= 2,
                icon: const Icon(CupertinoIcons.keyboard),
                title: 'Family Code',
                lineText: 'Enter code',
              ),
              EasyStep(
                enabled: maxReachedStep >= 3,
                icon: const Icon(CupertinoIcons.person_crop_circle_badge_checkmark),
                finishIcon: const Icon(CupertinoIcons.person_crop_circle_fill_badge_checkmark),
                title: 'Finish',
                lineText: 'Login!',
              ),
            ],
            onStepReached: (index) => setState(() => activeStep = index),
          ),
        ],
      ),
      //floatingActionButton: FloatingActionButton(onPressed: setProgress),
    );
  }

  /// Returns the next button.
  void _nextStep() {
    if (isLogin) {
      if (activeStep == 0) {
        setState(() {
          activeStep = 3;
          maxReachedStep = 3;
        });
      }
    } else {
      if (activeStep + 1 <= upperBound) {
        setState(() {
          activeStep += 1;
          maxReachedStep = activeStep;
        });
      }
    }
  }

  /// Returns the previous button.
  void _previousStep() {
    if (isLogin) {
      if (activeStep == 3) {
        setState(() {
          activeStep = 0;
        });
      }
    } else {
      if (activeStep - 1 > 0) {
        setState(() {
          activeStep -= 1;
        });
      }
    }
  }
}
