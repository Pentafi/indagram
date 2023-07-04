import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:indagram/providers/internet_provider.dart';
import 'package:indagram/providers/sign_in_provider.dart';
import 'package:indagram/utils/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Welcome to \nInstant-gram!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Sign in",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Log into your account using one of the options\n below",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedLoadingButton(
                  onPressed: handleGoogleSignIn,
                  controller: googleController,
                  successColor: Colors.red,
                  child: const Wrap(
                    children: [
                      Icon(
                        FontAwesomeIcons.google,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Google",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedLoadingButton(
                  onPressed: handleFacebookAuth,
                  controller: facebookController,
                  successColor: Colors.blue,
                  child: const Wrap(
                    children: [
                      Icon(
                        FontAwesomeIcons.facebook,
                        size: 20,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Facebook",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      handleNoInternetConnection();
      return;
    }

    await sp.signInWithGoogle();

    if (sp.hasError == true) {
      handleSignInError(sp.errorCode.toString());
      return;
    }

    // checking whether user exists or not
    final userExists = await sp.checkUserExists();
    handleUserExists(userExists);

    await sp.setSignIn();
    googleController.success();
  }

  void handleNoInternetConnection() {
    openSnackbar(context, "Check your Internet connection", Colors.red);
    googleController.reset();
  }

  void handleSignInError(String errorCode) {
    openSnackbar(context, errorCode, Colors.red);
    googleController.reset();
  }

  Future<void> handleUserExists(bool userExists) async {
    final sp = context.read<SignInProvider>();
    if (userExists) {
      // user exists
      await sp.getUserDataFromFirestore(sp.uid);
    } else {
      // user does not exist
      await sp.saveDataToFirestore();
    }
    await sp.saveDataToSharedPreferences();
  }

  Future<void> handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      handleNoInternetConnectionFacebook();
      return;
    }

    await sp.signInWithFacebook();

    if (sp.hasError == true) {
      handleSignInErrorFacebook(sp.errorCode.toString());
      return;
    }

    // checking whether user exists or not
    final userExists = await sp.checkUserExists();
    handleUserExistsFacebook(userExists);

    await sp.setSignIn();
    facebookController.success();
  }

  void handleNoInternetConnectionFacebook() {
    openSnackbar(context, "Check your Internet connection", Colors.red);
    facebookController.reset();
  }

  void handleSignInErrorFacebook(String errorCode) {
    openSnackbar(context, errorCode, Colors.red);
    facebookController.reset();
  }

  Future<void> handleUserExistsFacebook(bool userExists) async {
    final sp = context.read<SignInProvider>();
    if (userExists) {
      // user exists
      await sp.getUserDataFromFirestore(sp.uid);
    } else {
      // user does not exist
      await sp.saveDataToFirestore();
    }
    await sp.saveDataToSharedPreferences();
  }
}
