import 'package:expiry/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileRepository {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  Future<UserCredential> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  Future<UserCredential> createUser(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInEmailandPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<Profile?> getMyProfile() async {
    return (await profileRef.doc(_auth.currentUser?.uid).get()).data;
  }

  User? getUserAccount() {
    return _auth.currentUser;
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  Future<List<String>> checkAccount(String email) {
    return _auth.fetchSignInMethodsForEmail(email);
  }

  Future<void> updateProfile(Profile profile) {
    return profileRef.doc(_auth.currentUser?.uid).set(profile.copyWith(updatedAt: DateTime.now()));
  }

  Future<GoogleSignInAccount?> signInGoogle() {
    return _googleSignIn.signIn();
  }

  Future<UserCredential> signInWithCredential(AuthCredential authCredential) {
    return _auth.signInWithCredential(authCredential);
  }
}
