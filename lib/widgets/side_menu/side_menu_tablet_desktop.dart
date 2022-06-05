import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/provider/app_provider.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/widgets/navbar/navbar_logo.dart';
import 'package:admin_dashboard/widgets/side_menu/side_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuTabletDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.indigo,
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.indigo.shade600],
          ),
          boxShadow: [
            BoxShadow(
                color: (Colors.grey[200])!,
                offset: Offset(3, 5),
                blurRadius: 17)
          ]),
      width: 250,
      child: Container(
        child: Column(
          children: [
            NavBarLogo(),
            SideMenuItemDesktop(
              icon: Icons.dashboard,
              text: 'Dashboard',
              active: appProvider.currentPage == DisplayedPage.HOME,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.HOME);
                locator<NavigationService>().navigateTo(HomeRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.people,
              text: 'Users',
              active: appProvider.currentPage == DisplayedPage.USERS,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.USERS);

                locator<NavigationService>().navigateTo(UsersRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.manage_accounts,
              text: 'Users Roles',
              active: appProvider.currentPage == DisplayedPage.USERSROLES,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.USERSROLES);
                locator<NavigationService>().navigateTo(UsersRolesRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.book,
              text: 'Novels',
              active: appProvider.currentPage == DisplayedPage.NOVELS,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.NOVELS);
                locator<NavigationService>().navigateTo(NovelsRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.category,
              text: 'Genres',
              active: appProvider.currentPage == DisplayedPage.GENRES,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.GENRES);
                locator<NavigationService>().navigateTo(GenresRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.person,
              text: 'Authors',
              active: appProvider.currentPage == DisplayedPage.AUTHORS,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.AUTHORS);
                locator<NavigationService>().navigateTo(AuthorsRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.slideshow,
              text: 'Slideshows',
              active: appProvider.currentPage == DisplayedPage.SLIDESHOWS,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.SLIDESHOWS);
                locator<NavigationService>().navigateTo(SlideshowsRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
