import 'package:firebase_auth/firebase_auth.dart';
import 'package:floof/auth_screen.dart';
import 'package:floof/not_activated_screen.dart';
import 'package:floof/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bootstrapper.dart';
import 'firebase_options.dart';
import 'home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeData theme = AppTheme.getTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLOOF',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<bool>(
              future: Bootstrapper.bootstrapApp(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!
                      ? Home(
                          rerollTheme: () =>
                              setState(() => theme = AppTheme.getTheme()),
                        )
                      : const NotActivatedScreen();
                } else {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
