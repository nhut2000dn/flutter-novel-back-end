// ignore_for_file: deprecated_member_use
import 'package:admin_dashboard/provider/auth.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationTabletDesktop extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  NavigationTabletDesktop({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: (Colors.grey[200])!,
            offset: const Offset(3, 5),
            blurRadius: 17)
      ]),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 35,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: (authProvider.userModel.avatar != '')
                            ? FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                placeholder: 'images/loading.gif',
                                image: authProvider.userModel.avatar)
                            : const Image(
                                image: AssetImage('images/no_image.jpg')),
                      ),
                    ),
                    foregroundColor: Colors.black,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(
                    text: authProvider.userModel.fullName,
                  ),
                  myPopMenu(authProvider),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget myPopMenu(AuthProvider authProvider) {
    return PopupMenuButton(
      key: _key,
      icon: const Icon(Icons.keyboard_arrow_down),
      onSelected: (value) {},
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: InkWell(
            child: Row(
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.logout),
                ),
                Text('Logout')
              ],
            ),
            onTap: () {
              authProvider.signOut();
            },
          ),
        ),
      ],
    );
  }
}
