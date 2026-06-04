import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  String get displayName => auth.currentUser?.displayName ?? '';

  String get email => auth.currentUser?.email ?? '';

  String get photoUrl => auth.currentUser?.photoURL ?? '';

  Future<UserCredential?> signInWithGoogle() async {
    await googleSignIn.initialize();

    try {
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'FirebaseAuthException: code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      throw Exception('Google Sign In Error: $e');
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
