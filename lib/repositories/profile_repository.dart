import 'package:expiry/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final _auth = FirebaseAuth.instance;

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

  Future<void> updateProfile(Profile profile) {
    return profileRef.doc(_auth.currentUser?.uid).set(profile.copyWith(updatedAt: DateTime.now()));
  }
}
