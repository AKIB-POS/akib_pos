import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
	@override
	createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
	final FirebaseAuth _auth = FirebaseAuth.instance;
	final GoogleSignIn _googleSignIn = GoogleSignIn();
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

	Future<void> _signInWithEmail() async {
		try {
			UserCredential userCredential = await _auth.signInWithEmailAndPassword(
				email: _emailController.text,
				password: _passwordController.text,
			);
			// Handle successful sign-in
		} catch (e) {
			// Handle error
			print(e);
		}
	}

	Future<void> _signInWithGoogle() async {
		try {
			final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
			final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

			final UserCredential userCredential = await _auth.signInWithCredential(
				GoogleAuthProvider.credential(
					accessToken: googleAuth?.accessToken,
					idToken: googleAuth?.idToken,
				),
			);

			print(userCredential.user!.getIdToken());
			// Handle successful sign-in
		} catch (e, stackTrace) {
			// Handle error
			print(e);
			print(stackTrace);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text('Auth Page')),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					children: [
						TextField(
							controller: _emailController,
							decoration: InputDecoration(labelText: 'Email'),
						),
						TextField(
							controller: _passwordController,
							decoration: InputDecoration(labelText: 'Password'),
							obscureText: true,
						),
						SizedBox(height: 20),
						ElevatedButton(
							onPressed: _signInWithEmail,
							child: Text('Sign in with Email'),
						),
						ElevatedButton(
							onPressed: _signInWithGoogle,
							child: Text('Sign in with Google'),
						),
					],
				),
			),
		);
	}
}
