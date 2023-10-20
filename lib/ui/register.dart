import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storyapp_flutter/repo/repository.dart';
import 'package:storyapp_flutter/utils/utils.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final repo = Repository();

  bool isLoading = false;

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
            Text(message),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _emailController.text = '';
              _nameController.text = '';
              _passwordController.text = '';
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Registering..."),
          ],
        ),
      ),
    );

    if (_nameController.text.isEmpty) {
      _showToast("Name can't be empty");
    } else if (_emailController.text.isEmpty) {
      _showToast("Email can't be empty");
    } else if (_passwordController.text.isEmpty) {
      _showToast("Password can't be empty");
    } else {
      try {
        final response = await repo.register(_nameController.text,
            _emailController.text, _passwordController.text);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        if (response.error) {
          // ignore: use_build_context_synchronously
          _showResultDialog(context, response.message, isError: true);
        } else {
          // ignore: use_build_context_synchronously
          _showResultDialog(context, "Register Success");
        }
      } catch (e) {
        Navigator.pop(context); // Close loading dialog
        _showResultDialog(context, "Registration Failed \n ${e.toString()}",
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
              Image.asset(image2),
              Text(
                "Please Register",
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
                controller: _nameController,
                style: const TextStyle(color: InputColor),
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Name",
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
                      icon: const Icon(
                        Icons.email_rounded,
                        color: InputColor,
                      )),
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
                      "Register",
                      style: TextStyle(
                          color: White, fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: () {
                    _register();
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
                  Navigator.pop(context);
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
                    "Log In",
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
