import 'package:admin_dashboard/widgets/cards/cards_list.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:admin_dashboard/widgets/page_header.dart';
import 'package:admin_dashboard/widgets/charts/sales_chart.dart';
import 'package:admin_dashboard/widgets/top_buyer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(
          text: "DASHBOARD",
        ),
        CardsList(),
      ],
    );
  }
}
