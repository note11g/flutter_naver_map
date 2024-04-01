import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design/theme.dart';
import '../../design/custom_widget.dart';

class ExamplePageData {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final String? route;

  const ExamplePageData({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    required this.route,
  });

  Widget getItemWidget(BuildContext context) {
    return HalfActionButton(
      action: onTap ?? () => context.push(route ?? "/"),
      title: title,
      color: getColorTheme(context).onSurface,
      description: description,
      icon: icon,
    );
  }
}
