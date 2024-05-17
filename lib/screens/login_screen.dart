import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_app/services/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Spacer(),
              const Text("Login Screen"),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 40,
                ),
                child: ElevatedButton(
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
                  child: const Text("Sign In With Google..."),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
