import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:family_tree/Config_and_Extras/Material-theme/color_schemes.g.dart';
import 'package:family_tree/Config_and_Extras/Material-theme/custom_color.g.dart';
import 'package:family_tree/Config_and_Extras/config.dart';
import 'package:family_tree/Repositories/Interfaces/authentication_repo.dart';
import 'package:family_tree/Repositories/Repos/Firebase/authentication_repo_firebase.dart';
import 'package:family_tree/UI_Presentation/Navigation/Login_and_Register/LoginRegisterCubits/authentication_cubit.dart';
import 'package:family_tree/UI_Presentation/Navigation/welcome_splash_screen.dart';

import 'Repositories/Repos/ServerArchitecture/authentication_repo_server.dart';
import 'Repositories/repository_manager.dart';
import 'firebase_options.dart';

void main() async {
  if (server) {
    GetIt.I.registerSingleton<AuthenticationRepo>(AuthenticationRepoServer());
  } else {
    GetIt.I.registerSingleton<AuthenticationRepo>(AuthenticationRepoFirebase());
  }

  GetIt.I.registerSingleton<RepositoryManager>(RepositoryManager());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightScheme;
      ColorScheme darkScheme;

      if (lightDynamic != null && darkDynamic != null) {
        lightScheme = lightDynamic.harmonized();
        lightCustomColors = lightCustomColors.harmonized(lightScheme);

        // Repeat for the dark color scheme.
        darkScheme = darkDynamic.harmonized();
        darkCustomColors = darkCustomColors.harmonized(darkScheme);
      } else {
        // Otherwise, use fallback schemes.
        lightScheme = lightColorScheme;
        darkScheme = darkColorScheme;
      }
      return BlocProvider<AuthenticationCubit>(
        create: (BuildContext context) => AuthenticationCubit(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              useMaterial3: true,
            ),
            themeMode: ThemeMode.light,
            home: const WelcomeSplashScreen()),
      );
    });
  }
}
