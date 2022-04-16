import 'package:firebase_auth/firebase_auth.dart';
import 'package:floof/theme/style.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome\nYour Fluffiness, to",
                style: TextStyles.title,
                textAlign: TextAlign.center,
              ),
              Text(
                "Floof",
                style: TextStyles.title.copyWith(
                  fontFamily: 'PinyonScript',
                  letterSpacing: 2,
                  fontSize: 64,
                ),
              ),
              SizedBox(height: Insets.spacer),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        // Focused label style
                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      controller: emailController,
                    ),
                    SizedBox(height: Insets.med),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        // Focused label style
                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                      obscureText: true,
                      cursorColor: Theme.of(context).colorScheme.primary,
                      controller: passwordController,
                    ),
                    SizedBox(height: Insets.lg),
                    ElevatedButton(
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(50),
                      ),
                      onPressed: signIn,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (_) {
      showInvalidLoginDialog();
    }
  }

  void showInvalidLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Halt, Imposter!"),
        content: const Text(
            "YOUUUUUUU SCALLYWAG! You're not fluffy at all! Only the "
            "absolute floofiest are permitted to FLOOF past this point. Come "
            "back later when you're less lame."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
