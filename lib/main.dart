import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_core/firebase_core.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount _currentUser;
  final _auth = FirebaseAuth.instance;
  FirebaseUser logginUser;
  bool isLoggin = false;

  void getcurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          logginUser = user;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getcurrentUser();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:
            Scaffold(body: _currentUser != null ? loginBody() : logoutBody()));
  }

  Widget loginBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 200),
          RaisedButton(
            onPressed: () async {
              await _handleSignOut();
            },
            child: Text("Sing Out "),
            color: Colors.blue,
          ),
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
        ],
      ),
    );
  }
  //  showTodoList(),
  // floatingActionButton: FloatingActionButton(
  //   onPressed: () {
  //     showAddTodoDialog();
  //   },
  //   tooltip: 'Increment',
  //   child: Icon(Icons.add),
  // ),

  Widget logoutBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 200),
          Text(
            "You are not Sign in....",
            style: TextStyle(color: Colors.black),
          ),
          RaisedButton(
            onPressed: () async {
              await _handleSignIn();
            },
            child: Text("Sign In"),
          ),
        ],
      ),
    );
  }

  _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        isLoggin = true;
      });
    } catch (error) {
      print(error);
    }
  }

  _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      setState(() {
        isLoggin = false;
      });
    } catch (e) {
      print(e);
    }
  }
}
