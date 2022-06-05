// @dart=2.9
import 'package:admin_dashboard/pages/login/login.dart';
import 'package:admin_dashboard/provider/app_provider.dart';
import 'package:admin_dashboard/provider/auth.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/rounting/router.dart';
import 'package:admin_dashboard/widgets/layout/layout.dart';
import 'package:admin_dashboard/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers/costants.dart';
import 'locator.dart';

void main() {
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AppProvider.init()),
    ChangeNotifierProvider.value(value: AuthProvider.initialize()),
    ChangeNotifierProvider.value(value: TablesProvider.init()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      onGenerateRoute: generateRoute,
      initialRoute: PageControllerRoute,
    );
  }
}

class AppPagesController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder(
      // Initialize FlutterFire:
      future: initialization,
      builder: (context, snapshot) {
        // return LayoutTemplate();
        // // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text("Something went wrong")],
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          debugPrint(authProvider.status.toString());
          switch (authProvider.status) {
            case Status.Uninitialized:
              return const Loading();
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return LayoutTemplate();
            default:
              return LoginPage();
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [CircularProgressIndicator()],
          ),
        );
      },
    );
  }
}
