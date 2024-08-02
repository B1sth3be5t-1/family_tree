import '../../Interfaces/authentication_repo.dart';

class AuthenticationRepoServer implements AuthenticationRepo {
  @override
  Future<void> logInUser(String u, String p) async {
    // var client = http.Client();
    // try {
    //   var response = await client.post(Uri.parse('${getUrl()}token'),
    //       headers: {'Content-Type': 'application/json'},
    //       body: jsonEncode({'username': u, 'password': p}));
    //   if (response.statusCode == 200) {
    //     await StorageSingleton().secureStorage.write(
    //         key: 'refresh', value: json.decode(response.body)['refresh']);
    //     await StorageSingleton()
    //         .secureStorage
    //         .write(key: 'access', value: json.decode(response.body)['access']);
    //     return true;
    //   }
    //   return false;
    // } catch (e) {
    //   return false;
    // } finally {
    //   client.close();
    // }
  }

  @override
  Future<void> registerUser(
      String u, String p, String fName, String lName, String? familyCode) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
