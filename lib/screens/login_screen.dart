import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.hideLoginButton});

  final bool? hideLoginButton;

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AuthService authService = AuthService();
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void initState() {
    super.initState();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      }
    });

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      _controller.stop();
      _controller.reset();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent.shade100,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      color: Colors.white,
                      width: 120,
                    ),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 4 * 3.14159, // Two turns
                        child: child,
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "DOKTO",
                    style: kTitle1Style.copyWith(
                        fontSize: 38, color: Colors.white),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 80,
                ),
                child: widget.hideLoginButton == true
                    ? const Text('')
                    : ElevatedButton(
                        onPressed: () async {
                          authService.googleSignIn().then(
                                (value) => {
                                  if (value != null)
                                    {
                                      // navigate to home screen
                                      print(value.displayName)
                                    }
                                  else
                                    {print("Login Failed")}
                                },
                              );
                        },
                        child: Text(
                          "Sign In With Google",
                          style: TextStyle(color: Colors.indigoAccent.shade200),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
