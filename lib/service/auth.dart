import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  //firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  //create a user from firebase user with uid
  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //create the stream for checking the auth changes in the user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((User? user) {
      final userModel = _userWithFirebaseUserUid(user);
      print('Auth state changed: ${user?.uid} -> ${userModel?.uid}');
      return userModel;
    });
  }

  //sign in with email and password
  Future<UserModel?> signInUsingEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (e) {
      return null;
    }
  }

  //register with email and password
  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName(name);
      }
      return _userWithFirebaseUserUid(user);
    } catch (e) {
      return null;
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      print('Starting sign out process...');

      // Check if user is currently signed in with Google
      final currentUser = _auth.currentUser;
      final isGoogleUser =
          currentUser?.providerData.any(
            (info) => info.providerId == 'google.com',
          ) ??
          false;

      print('Current user: ${currentUser?.uid}');
      print('Is Google user: $isGoogleUser');

      // Sign out from Google Sign-In if user was signed in with Google
      if (isGoogleUser) {
        try {
          // Check if Google Sign-In is currently signed in
          final googleUser = await _googleSignIn.signInSilently();
          if (googleUser != null) {
            await _googleSignIn.signOut();
            print('Google Sign-In signed out successfully');
          } else {
            print('No Google Sign-In user found');
          }
        } catch (googleError) {
          print('Error signing out from Google: $googleError');
        }
      }

      // Sign out from Firebase
      await _auth.signOut();
      print('Firebase signed out successfully');

      print('Sign out process completed');
    } catch (e) {
      print('Error during sign out: $e');
      // Re-throw the error so the UI can handle it
      rethrow;
    }
  }

  //sign in with google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) return null;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;
      return _userWithFirebaseUserUid(user);
    } catch (e) {
      return null;
    }
  }
}
