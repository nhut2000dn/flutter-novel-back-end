import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/provider/auth.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:admin_dashboard/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.indigo.shade600])),
      child: authProvider.status == Status.Authenticating
          ? Loading()
          : Scaffold(
              key: _key,
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  color: Colors.red,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 3),
                              blurRadius: 24)
                        ]),
                    height: 400,
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: "LOGIN",
                          size: 22,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: authProvider.email,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    icon: Icon(Icons.email_outlined)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                obscureText: true,
                                controller: authProvider.password,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    icon: Icon(Icons.lock_open)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              CustomText(
                                text: "Forgot password?",
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.indigo),
                            child: FlatButton(
                              onPressed: () async {
                                if (!await authProvider.signIn()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Login failed!")));
                                  return;
                                }
                                authProvider.clearController();

                                locator<NavigationService>()
                                    .globalNavigateTo(LayoutRoute, context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CustomText(
                                      text: "LOGIN",
                                      size: 22,
                                      color: Colors.white,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomText(
                                text: "Do not have an account? ",
                                size: 16,
                                color: Colors.grey,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    locator<NavigationService>()
                                        .globalNavigateTo(
                                            RegistrationRoute, context);
                                  },
                                  child: const CustomText(
                                    text: "Sign up here. ",
                                    size: 16,
                                    color: Colors.indigo,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
