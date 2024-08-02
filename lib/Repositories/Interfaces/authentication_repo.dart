// Authentication API
abstract class AuthenticationRepo {
  // Gets tokens from the server (stores them in cryptographically secure
  // local storage)
  Future<void> logInUser(String u, String p);

  // Refreshes tokens
  Future<void> registerUser(
      String u, String p, String fName, String lName, String? familyCode);
}
