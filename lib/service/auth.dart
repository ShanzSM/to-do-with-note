import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  //firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //create a user from firebase user with uid
  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //create the stream for checking the auth changes in the user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  //sign in using email & password
  Future singnaInUsingEmailAndPassord(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //sign in using Google
  Future signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  //register using email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
