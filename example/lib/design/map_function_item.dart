import 'package:flutter/material.dart';
import 'package:flutter_bottom_drawer/flutter_bottom_drawer.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';

import 'theme.dart';

typedef MapFunctionItemOnTap = void Function(MapFunctionItem item);
typedef MapFunctionItemOnBack = void Function();

class MapFunctionItem {
  final String title;
  final String description;
  final IconData icon;
  final MapFunctionItemOnTap? onTap;
  final Widget Function(bool canScroll)? page;
  final MapFunctionItemOnBack? onBack;

  final bool isScrollPage;
  DrawerMoveController? drawerController;

  MapFunctionItem({
    required this.title,
    required this.description,
    required this.icon,
    this.page,
    this.onTap,
    this.onBack,
    this.isScrollPage = true,
    this.drawerController,
  });

  bool get needItemOnTap => onTap == null;

  Widget getItemWidget(BuildContext context) {
    return HalfActionButton(
      action: onTap != null ? () => onTap!.call(this) : null,
      title: title,
      color: getColorTheme(context).onSurface,
      description: description,
      icon: icon,
    );
  }

  Widget getPageWidget(BuildContext context, {bool canScroll = true}) {
    assert(page != null);
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              IconButton(
                  onPressed: onBack,
                  padding: const EdgeInsets.all(16),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
              Text(title, style: getTextTheme(context).titleLarge),
            ]),
            _drawerAutoControlButton(),
          ]),
      page!(canScroll)
    ]);
  }

  Widget _drawerAutoControlButton() {
    if (drawerController == null) return const SizedBox();
    DrawerState drawerState = drawerController!.nowState;

    return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: StatefulBuilder(builder: (context, setStateButton) {
          return InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                if (drawerController == null) return;
                drawerController!.autoMove();
                drawerState = drawerController!.nowState;
                setStateButton(() {});
              },
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(drawerState == DrawerState.opened ? "접기" : "펼치기",
                      style: getTextTheme(context)
                          .labelSmall
                          ?.copyWith(color: getColorTheme(context).primary))));
        }));
  }

  MapFunctionItem copyWith({
    String? title,
    String? description,
    MapFunctionItemOnTap? onTap,
    Widget Function(bool canScroll)? page,
    MapFunctionItemOnBack? onBack,
    bool? isScrollPage,
    DrawerMoveController? drawerController,
    IconData? icon,
  }) {
    return MapFunctionItem(
      title: title ?? this.title,
      description: description ?? this.description,
      onTap: onTap ?? this.onTap,
      page: page ?? this.page,
      onBack: onBack ?? this.onBack,
      isScrollPage: isScrollPage ?? this.isScrollPage,
      drawerController: drawerController ?? this.drawerController,
      icon: icon ?? this.icon,
    );
  }
}
