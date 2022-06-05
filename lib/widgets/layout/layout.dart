import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/rounting/router.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/widgets/side_menu/side_menu.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../navbar/navigation_bar.dart';

class LayoutTemplate extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  LayoutTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      drawer: Container(
        color: Colors.white,
        child: ListView(
          children: const [
            UserAccountsDrawerHeader(
              accountEmail: Text("abc@gmail.com"),
              accountName: Text("Santos Enoque"),
            ),
            ListTile(
              title: Text("Lessons"),
              leading: Icon(Icons.book),
            )
          ],
        ),
      ),
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Column(
              children: [
                NavigationBar(
                  scaffoldState: _key,
                ),
                Expanded(
                  child: Navigator(
                    key: locator<NavigationService>().navigatorKey,
                    onGenerateRoute: generateRoute,
                    initialRoute: HomeRoute,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
