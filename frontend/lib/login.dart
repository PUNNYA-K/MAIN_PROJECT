import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:main_project/signup.dart';
import 'searchpage.dart'; // Ensure homepage.dart exists

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // For showing loading indicator

Future<void> login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  final String username = _usernameController.text.trim();
  final String password = _passwordController.text.trim();
  const String apiUrl = "http://127.0.0.1:8000/api/login/";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    final responseData = jsonDecode(response.body);
    print("Response Data: $responseData");

    if (response.statusCode == 200) {
      // Safely handle potential null values
      String? token = responseData["token"];
      String? responseUsername = responseData["username"];

      if (responseUsername != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"] ?? "Login Successful!")),
        );

        // Navigate to HomePage, using a null-safe username
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(username: responseUsername)),
        );
      } else {
        // Handle case where username is null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid response from server")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData["error"] ?? "Login Failed")),
      );
    }
  } catch (e) {
    print("Error: $e"); // Debugging log
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Something went wrong. Please try again!")),
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
                    'LOGIN',
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
                    } else if (!RegExp(r'^[a-z0-9]+$').hasMatch(value)) {
                      return 'Username should contain only lowercase letters & numbers';
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  _buildTextField('Password', true, _passwordController, Icons.lock, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : _buildButton('Login', login),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inder',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupPage()));
                        },
                        child: const Text(
                          "Sign Up",
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
        hintText: 'Enter your $label',
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 26, 66, 126)),
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

  Widget _buildButton(String text, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 26, 66, 126),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Inder'),
      ),
    );
  }
}
