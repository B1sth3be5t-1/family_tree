import 'package:family_tree/Config_and_Extras/config.dart';

import 'Interfaces/authentication_repo.dart';
import 'Repos/Firebase/authentication_repo_firebase.dart';
import 'Repos/ServerArchitecture/authentication_repo_server.dart';

class RepositoryManager {
  final AuthenticationRepo authRepo;

  // Private constructor that initializes each repository pointer
  RepositoryManager._(this.authRepo);

  // Factory that initializes each repository with either the testing mock
  // or the actual implementation, depending on the configuration
  factory RepositoryManager() {
    // Checks the config, instantiates appropriate implementations
    if (server) {
      var authRepo = AuthenticationRepoServer();
      return RepositoryManager._(authRepo);
    } else {
      var authRepo = AuthenticationRepoFirebase();
      return RepositoryManager._(authRepo);
    }
  }
}
