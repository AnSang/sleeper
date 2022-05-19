import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthentication {
  // The entrypoint of the firebase auth SDK
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; // Instanace of FirebaseAuth:

  final GoogleSignIn googleSignIn = GoogleSignIn(); // Instanace of GoogleSignIn

  // Method for Google login
  Future<String?> loginWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult = await _firebaseAuth.signInWithCredential(authCredential);
    final User? user = authResult.user;
    if (user != null) {
      return '$user';
    }
    return null;
  }

// Method for create a new user action
  Future<String?> createUser(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!.uid;
    } on FirebaseAuthException {
      return null;
    }
  }

// Method for login action
  Future<String?> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user!.uid;
    } on FirebaseAuthException {
      return null;
    }
  }

// Method for log out action
  Future<bool> logout() async {
    try {
      _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }





  /*//////// FaceBook /////////////
  Future<String?> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    final UserCredential authResult = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    final User? user = authResult.user;
    if (user != null) {
      return '$user';
    }
    return null;
  }*/

  //////// GitHub /////////////
  Future<String?> signInWithGitHub(BuildContext context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: 'Iv1.ef519b5e69a41705',
      clientSecret: 'b2905ce952aa9e5d398520c7a8fe62de5879ee66',
      redirectUrl: 'https://wakeup-9bca5.firebaseapp.com/__/auth/handler'
    );

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    // Create a credential from the access token
    final githubAuthCredential = GithubAuthProvider.credential(result.token!);

    // Once signed in, return the UserCredential
    final UserCredential authResult =  await _firebaseAuth.signInWithCredential(githubAuthCredential);
    final User? user = authResult.user;
    if (user != null) {
      return '$user';
    }
    return null;
  }


  /*//////// KaKao /////////////
  Future<String?> signInWithKaKao() async {
    final installed = await kakao.isKakaoTalkInstalled().then((value1) async { // Kakao 설치 여부 확인
      try {
        kakao.KakaoContext.clientId = 'aa2066b021be69a35115d04dfbffb4bb';
        var code = value1 ? await kakao.AuthCodeClient.instance.requestWithTalk() : await kakao.AuthCodeClient.instance.request();
        await kakao.AuthApi.instance.issueAccessToken(code).then((value2) {
          try {
            kakao.DefaultTokenManager().setToken(value2);
            var userInfo = _getUser();
          } catch (e) {
            print(e);
          }
        });
      } catch (e) {
        print(e);
      }
    });
  }

  Future<bool> _getUser() async {
    try {
      var user = await kakao.UserApi.instance.me();
      print(user.toString());
      return true;
    } on kakao.KakaoAuthException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return true;
    }
  }*/
}
