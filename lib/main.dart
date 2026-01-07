import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/widgets/offline_banner.dart';
import 'package:provider/provider.dart';

import 'providers/authentication_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/notes_provider.dart';
import 'screens/login_screen.dart';
import 'screens/notes_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.enableNetwork();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProxyProvider<AuthenticationProvider, NotesProvider>(
          create: (_) => NotesProvider(null),
          update: (_, auth, prev) => NotesProvider(auth.userId)..copyFrom(prev),
        ),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthenticationProvider>();
    final connectivity = context.watch<ConnectivityProvider>();
    Widget home = auth.isLoading // Add loading to provider if needed
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : auth.isLoggedIn
        ? const NotesListScreen()
        : const LoginScreen();

    return MaterialApp(
      scaffoldMessengerKey: connectivity.scaffoldKey,
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      home:  home,
      builder: (context, child) => Scaffold(
        body: Stack(
          children: [
            child!,
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: const OfflineBanner(),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
