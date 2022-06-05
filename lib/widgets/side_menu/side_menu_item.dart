import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SideMenuItemDesktop extends StatelessWidget {
  final bool active;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const SideMenuItemDesktop(
      {Key? key,
      required this.active,
      required this.text,
      required this.icon,
      required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: active ? Colors.green.withOpacity(.3) : null,
      leading: Icon(icon, color: Colors.white),
      title: CustomText(
        text: text,
        color: Colors.white,
        size: active ? 23 : 18,
        weight: active ? FontWeight.bold : FontWeight.w300,
      ),
    );
  }
}
