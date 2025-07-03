import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/user_model.dart';
import 'package:todo_app/service/auth.dart';

class Login extends StatefulWidget {
  final Function toggle;
  const Login({super.key, required this.toggle});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //ref for AuthService class
  final AuthServices _auth = AuthServices();

  //create a user from firebase user with uid
  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //create the stream for checking the auth changes in the user

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  //email and password store
  String email = "";
  String password = "";
  String error = "";

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  validator: (val) =>
                      val?.isEmpty == true ? "Enter a valid email" : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (val) =>
                      val!.length < 6 ? "Enter a valid password" : null,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _auth
                                .singnaInUsingEmailAndPassord(email, password);
                            if (result == null) {
                              setState(() {
                                error = "Login failed. Please try again.";
                              });
                            }
                          }
                        }
                      : null,
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: Image.asset('assets/google.png', height: 24, width: 24),
                  label: const Text('Sign in with Google'),
                  onPressed: () async {
                    dynamic result = await _auth.signInWithGoogle();
                    if (result == null) {
                      setState(() {
                        error = "Google sign-in failed. Please try again.";
                      });
                    }
                    // On success, Wrapper will automatically navigate to HomePage
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to registration page
                        widget.toggle();
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
