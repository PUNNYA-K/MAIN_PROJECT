import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> signUp(BuildContext context, String email, String password) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign Up Successful! Please verify your email.")),
      );

      // Redirect to login page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));

    } on FirebaseAuthException catch (e) {
      String message = "Signup Failed!";
      if (e.code == 'email-already-in-use') {
        message = "Email is already in use!";
      } else if (e.code == 'weak-password') {
        message = "Password must be at least 6 characters!";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format!";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(163, 200, 236, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 26, 66, 126),
                      fontFamily: 'WendyOne',
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                    'Email',
                    false,
                    _emailController,
                    Icons.email,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                        return 'Enter a valid email with @gmail.com';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Password',
                    true,
                    _passwordController,
                    Icons.lock,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Confirm Password',
                    true,
                    _confirmPasswordController,
                    Icons.lock_outline,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password is required';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildButton('Sign Up'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inder',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color.fromARGB(255, 26, 66, 126),
                            fontFamily: 'Inder',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
      ),
    );
  }

  Widget _buildTextField(
    String label,
    bool obscureText,
    TextEditingController controller,
    IconData icon,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: const Color.fromARGB(255, 26, 66, 126),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 26, 66, 126)),
        labelStyle: const TextStyle(color: Colors.black, fontFamily: 'Inder'),
        hintText: 'Enter your $label',
        hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Inder'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 43, 93, 153), width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      validator: validator,
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              signUp(context, _emailController.text, _passwordController.text);
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 26, 66, 126),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              text,
              style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Inder'),
            ),
    );
  }
}
