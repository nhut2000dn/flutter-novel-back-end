import 'package:admin_dashboard/provider/app_provider.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card_item.dart';

class CardsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    TablesProvider tablesProvider = Provider.of<TablesProvider>(context);

    return Expanded(
      child: Container(
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          padding: const EdgeInsets.all(4.0),
          children: [
            CardItem(
              icon: Icons.monetization_on_outlined,
              title: "Users",
              subtitle: "total registered users on the app",
              value: "${tablesProvider.usersTableSource.length}",
              color1: Colors.green.shade700,
              color2: Colors.green,
            ),
            CardItem(
              icon: Icons.shopping_basket_outlined,
              title: "Users Roles",
              subtitle: "Total users roles",
              value: "${tablesProvider.usersRolesTableSource.length}",
              color1: Colors.lightBlueAccent,
              color2: Colors.blue,
            ),
            CardItem(
              icon: Icons.delivery_dining,
              title: "Novels",
              subtitle: "Total novel on the app",
              value: "${tablesProvider.novelsTableSource.length}",
              color1: Colors.redAccent,
              color2: Colors.red,
            ),
            CardItem(
              icon: Icons.delivery_dining,
              title: "Genres",
              subtitle: "Total genres on the app",
              value: "${tablesProvider.genresTableSource.length}",
              color1: Colors.yellow.shade900,
              color2: Colors.yellow.shade600,
            ),
            CardItem(
              icon: Icons.delivery_dining,
              title: "Authors",
              subtitle: "Total authors on the app",
              value: "${tablesProvider.authorsTableSource.length}",
              color1: Colors.purpleAccent,
              color2: Colors.purple,
            ),
            CardItem(
              icon: Icons.delivery_dining,
              title: "Slideshow",
              subtitle: "Total slideshow on the app",
              value: "${tablesProvider.slideshowTableSource.length}",
              color1: Colors.grey.shade900,
              color2: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
