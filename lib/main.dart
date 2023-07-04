import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:indagram/providers/internet_provider.dart';
import 'package:indagram/providers/sign_in_provider.dart';
import 'package:indagram/screens/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InternetProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Indagram',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
          // Customize other theme properties here
        ),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const LoginScreen();
            }

            // Show a loading indicator while Firebase initializes
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
