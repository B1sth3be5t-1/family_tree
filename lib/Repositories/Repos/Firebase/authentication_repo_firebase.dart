import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:family_tree/Repositories/Models/user.dart' as mod_user;
import 'dart:math';

import '../../Interfaces/authentication_repo.dart';
import '../../storage.dart';

class AuthenticationRepoFirebase implements AuthenticationRepo {
  @override
  Future<void> logInUser(String u, String p) async {
    u = u.toLowerCase();
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: u,
        password: p,
      );

      var userInfo =
          FirebaseFirestore.instance.collection('users').doc(cred.user!.uid);

      var info = await userInfo.get();
      var data = info.data();

      if (data!.isEmpty) throw Exception('');

      mod_user.User user = mod_user.User(
          fName: data['fName'],
          lName: data['lName'],
          email: u,
          userCredential: cred,
          familyCode: data['family_code']);

      CurrentUserSingleton.currentUser = user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('weak-password');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('email-in-use');
      } else {
        throw Exception('unknown-error');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registerUser(String u, String p, String fName, String lName,
      String? familyCode) async {
    u = u.toLowerCase();
    CollectionReference familyCodes =
        FirebaseFirestore.instance.collection('familyCodes');
    bool found = false;
    try {
      if (familyCode != '') {
        var info = await familyCodes.get();
        var data = info.docs;

        for (QueryDocumentSnapshot name in data) {
          if (name.get('family_code') == familyCode) {
            found = true;
            break;
          }
        }
        if (!found) {
          throw Exception('family_not_found');
        }
      } else {
        familyCode = getRandomString(10).toUpperCase();
      }

      final userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: u,
        password: p,
      );

      CollectionReference userInfo =
          FirebaseFirestore.instance.collection('users');

      userInfo.doc(userCred.user!.uid).set({
        'email': u,
        'fName': fName,
        'lName': lName,
        'uid': userCred.user!.uid,
        'family_code': familyCode
      });

      //add to family codes
      if (!found) {
        familyCodes.add({
          'family_code': familyCode,
        });
      }

      //catch errors
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('weak-password');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('email-in-use');
      } else {
        throw Exception('unknown-error');
      }
    } catch (e) {
      rethrow;
    }
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
