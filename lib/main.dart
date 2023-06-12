import 'package:data_operations_service/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/src/services/authentication_service.dart';
import 'package:login/src/utils/response.dart';
import 'package:login/src/utils/status_code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyAuthApp());
}


class MyAuthApp extends StatelessWidget {
  const MyAuthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authService = AuthenticationService();
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: authService.checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final AppResponse response = snapshot.data as AppResponse;
            if (response.status == StatusCode.ok) {
              return const MyDataApp();
            } else {
              return LoginScreen(authenticationService: authService);
            }
          }
        },
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.authenticationService}) : super(key: key);

  final AuthenticationService authenticationService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        controller: _email,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final passwordField = TextFormField(
        controller: _password,
        autofocus: false,
        obscureText: true,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          widget.authenticationService
              .signInWithEmailAndPassword(_email.text, _password.text);

          const navigationTimeout = Duration(seconds: 10);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Show a loading dialog while waiting for the navigation
              return const AlertDialog(
                title: Text('Loading'),
                content: Text('Navigating to fridge...'),
              );
            },
          );

          Future.delayed(navigationTimeout).timeout(navigationTimeout,
              onTimeout: () {
            // Handle timeout error
            Navigator.pop(context); // Dismiss the loading dialog

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Timeout Error'),
                  content: const Text('Navigation to fridge timed out.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            return; // Return early or perform any necessary cleanup
          }).then((_) {
            // Navigation completed successfully
            Navigator.pop(context); // Dismiss the loading dialog
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyDataApp()),
            );
          }).catchError((error) {
            // Handle other errors
            Navigator.pop(context); // Dismiss the loading dialog

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text('Navigation to fridge failed: $error'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          });
        },
        child: Text(
          "Login",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sign In Page'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  const Text(
                      'email@gmail.com si password:D memoria mea de furnica :)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 10.0),
                  const Text('Welcome - Please log in',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 10.0),
                  emailField,
                  const SizedBox(height: 10.0),
                  passwordField,
                  const SizedBox(height: 10.0),
                  saveButton,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
