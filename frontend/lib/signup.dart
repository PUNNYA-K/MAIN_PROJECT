import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  final String apiUrl = "http://127.0.0.1:8000/api/register/";

  Future<void> signUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "confirm_password": _confirmPasswordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"] ?? "Signup Successful!")),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["error"] ?? "Signup Failed!")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect to server. Check your internet.")),
      );
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
                  _buildTextField('Username', false, _usernameController, Icons.person, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  _buildTextField('Email', false, _emailController, Icons.email, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  _buildTextField('Password', true, _passwordController, Icons.lock, (value) {
                    if (value == null || value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  _buildTextField('Confirm Password', true, _confirmPasswordController, Icons.lock, (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : _buildButton('Sign Up'),
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

  Widget _buildTextField(String label, bool obscureText, TextEditingController controller, IconData icon, String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: const Color.fromARGB(255, 26, 66, 126),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 26, 66, 126)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
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
      onPressed: () => signUp(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 26, 66, 126),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: Text(text, style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Inder')),
    );
  }
}