import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storyapp_flutter/ui/home.dart';
import 'package:storyapp_flutter/ui/register.dart';
import 'package:storyapp_flutter/utils/utils.dart';

import '../repo/repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final repository = Repository();

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  Future<void> _showResultDialog(BuildContext context, String message,
      {bool isError = false}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isError ? Icons.error : Icons.check_circle,
                size: 48, color: isError ? Colors.red : Colors.green),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!isError) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }
              if (isError) {
                Navigator.pop(context);
                _emailController.text = '';
                _passwordController.text = '';
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Login....."),
          ],
        ),
      ),
    );

    if (_emailController.text.isEmpty) {
      _showToast("Email can't be empty");
      Navigator.pop(context);
    } else if (_passwordController.text.isEmpty) {
      _showToast("Password can't be empty");
      Navigator.pop(context);
    } else {
      try {
        final response = await repository.login(
            _emailController.text.trim(), _passwordController.text.trim());
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        if (response.error) {
          // ignore: use_build_context_synchronously
          _showResultDialog(context, response.message, isError: true);
        } else {
          // ignore: use_build_context_synchronously
          _showResultDialog(context, "Login Success");
        }
      } catch (e) {
        Navigator.pop(context); // Close loading dialog
        _showResultDialog(context, "Login failed \n ${e.toString()}",
            isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [g1, g2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(size.height * 0.030),
          child: Column(
            children: [
              Image.asset(image1),
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: White.withOpacity(0.7),
                ),
              ),
              Text(
                "Please Log In",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: White.withOpacity(0.7),
                ),
              ),
              SizedBox(
                height: size.height * 0.024,
              ),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: InputColor),
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Email",
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person_2_rounded)),
                  fillColor: White,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37)),
                ),
              ),
              SizedBox(
                height: size.height * 0.020,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: InputColor),
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Password",
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.vpn_key_rounded)),
                  fillColor: White,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37)),
                ),
              ),
              SizedBox(
                height: size.height * 0.030,
              ),
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: size.height * 0.080,
                    decoration: BoxDecoration(
                        color: ButtonColor,
                        borderRadius: BorderRadius.circular(37)),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                          color: White, fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: () {
                    _login();
                  }),
              SizedBox(
                height: size.height * 0.040,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 150,
                    height: 1,
                    color: Colors.white54,
                  ),
                  const Text(
                    "OR",
                    style: TextStyle(
                        color: White,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Container(
                    width: 150,
                    height: 1,
                    color: Colors.white54,
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.040,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(37),
                color: Color.fromRGBO(225, 225, 225, 0.25),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: size.height * 0.080,
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 45,
                      spreadRadius: 0,
                      color: Color.fromRGBO(120, 37, 138, 0.25),
                    )
                  ]),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: White, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
