import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  late DisplayedPage currentPage;
  late double numberOfUsers = 0;
  late double numberOfUsersRoles = 0;
  late double numberOfNovels = 0;
  late double numberOfGenres = 0;
  late double numberOfAuthors = 0;

  AppProvider.init() {
    _getRevenue();
    changeCurrentPage(DisplayedPage.HOME);
  }

  changeCurrentPage(DisplayedPage newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  void _getRevenue() async {
    // await _orderServices.getAllOrders().then((orders) {
    //   // for (OrderModel order in orders) {
    //   //   revenue = revenue + order.total;
    //   //   print("======= TOTAL REVENUE: ${revenue.toString()}");
    //   //   print("======= TOTAL REVENUE: ${revenue.toString()}");
    //   //   print("======= TOTAL REVENUE: ${revenue.toString()}");
    //   // }
    //   notifyListeners();
    // });
  }
}
