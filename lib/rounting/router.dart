import 'package:admin_dashboard/pages/authors/add_author_page.dart';
import 'package:admin_dashboard/pages/authors/authors_page.dart';
import 'package:admin_dashboard/pages/authors/edit_author_page.dart';
import 'package:admin_dashboard/pages/genres/add_genre_page.dart';
import 'package:admin_dashboard/pages/genres/edit_genre_page.dart';
import 'package:admin_dashboard/pages/genres/genres_page.dart';
import 'package:admin_dashboard/pages/login/login.dart';
import 'package:admin_dashboard/pages/novels/add_novel_page.dart';
import 'package:admin_dashboard/pages/novels/edit_novel_page.dart';
import 'package:admin_dashboard/pages/novels/novels_page.dart';
import 'package:admin_dashboard/pages/registration/registration.dart';
import 'package:admin_dashboard/pages/sliedshows/add_slideshow_page.dart';
import 'package:admin_dashboard/pages/sliedshows/edit_slideshow_page.dart';
import 'package:admin_dashboard/pages/sliedshows/slideshows_page.dart';
import 'package:admin_dashboard/pages/users/add_user_page.dart';
import 'package:admin_dashboard/pages/users/edit_user_page.dart';
import 'package:admin_dashboard/pages/users_roles/add_user_role_page.dart';
import 'package:admin_dashboard/pages/users_roles/edit_user_role_page.dart';
import 'package:admin_dashboard/pages/users_roles/users_roles_page.dart';
import 'package:admin_dashboard/widgets/layout/layout.dart';

import '../main.dart';
import '../pages/home/home_page.dart';
import '../pages/users/users_page.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  print('generateRoute: ${settings.name}');
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(HomePage());
    case LoginRoute:
      return _getPageRoute(LoginPage());
    case RegistrationRoute:
      return _getPageRoute(RegistrationPage());
    case LayoutRoute:
      return _getPageRoute(LayoutTemplate());
    // User Role Router
    case UsersRolesRoute:
      return _getPageRoute(UsersRolesPage());
    case AddUserRoleRoute:
      return _getPageRoute(AddUserRolePage());
    case EditUserRoleRoute:
      return _getPageRoute(
          EditUserRolePage(argument: args as Map<String, dynamic>));
    // User Router
    case UsersRoute:
      return _getPageRoute(UsersPage());
    case AddUserRoute:
      return _getPageRoute(AddUserPage());
    case EditUserRoute:
      return _getPageRoute(
          EditUserPage(argument: args as Map<String, dynamic>));
    // Novel Router
    case NovelsRoute:
      return _getPageRoute(NovelsPage());
    case AddNovelRoute:
      return _getPageRoute(AddNovelPage());
    case EditNovelRoute:
      return _getPageRoute(
          EditNovelPage(argument: args as Map<String, dynamic>));
    // Genre Router
    case GenresRoute:
      return _getPageRoute(GenresPage());
    case AddGenreRoute:
      return _getPageRoute(AddGenrePage());
    case EditGenreRoute:
      return _getPageRoute(
          EditGenrePage(argument: args as Map<String, dynamic>));
    // Author Router
    case AuthorsRoute:
      return _getPageRoute(AuthorsPage());
    case AddAuthorRoute:
      return _getPageRoute(AddAuthorPage());
    case EditAuthorRoute:
      return _getPageRoute(
          EditAuthorPage(argument: args as Map<String, dynamic>));
    // Author Router
    case SlideshowsRoute:
      return _getPageRoute(SlideshowsPage());
    case AddSlideshowRoute:
      return _getPageRoute(AddSlideshowPage());
    case EditSlideshowRoute:
      return _getPageRoute(
          EditSlideshowPage(argument: args as Map<String, dynamic>));
    case PageControllerRoute:
      return _getPageRoute(AppPagesController());
    default:
      return _getPageRoute(LoginPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}
