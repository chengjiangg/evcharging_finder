import 'package:firebase_auth/firebase_auth.dart';

class AuthClass {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User> get authStateChanges => auth.idTokenChanges();

  // GET UID
  String getCurrentUID() {
    return auth.currentUser.uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return auth.currentUser;
  }

  // create Account
  Future<String> createAccount({String email, String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "The password is too weak";
      } else if (e.code == 'email-already-in-use') {
        return "The account already exists for that email";
      }
    } catch (e) {
      return "Error occured";
    }
  }

  // sign in user
  Future<String> signIn({String email, String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Welcome";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    } catch (e) {
      print(e);
    }
  }

  //reset password
  Future<String> resetPassword({String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return "Email Sent";
    } catch (e) {}
  }

  // sign out
  void signOut() {
    auth.signOut();
  }
}
