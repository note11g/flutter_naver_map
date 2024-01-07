import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bottom_drawer/flutter_bottom_drawer.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';

import '../../design/map_function_item.dart';
import '../../design/theme.dart';

class ExampleAppBottomDrawer {
  final BuildContext context;
  final Function(double height) onDrawerHeightChanged;
  final Function() rebuild;
  final List<MapFunctionItem> pages;
  final void Function()? onPageDispose;

  ExampleAppBottomDrawer({
    required this.context,
    required this.onDrawerHeightChanged,
    required this.rebuild,
    required this.pages,
    this.onPageDispose,
  });

  ColorScheme get colorTheme => getColorTheme(context);

  TextTheme get textTheme => getTextTheme(context);

  late DrawerMoveController drawerController;
  late DrawerState drawerState;
  late Function(Function()) drawerSetState;

  MapFunctionItem? nowItem;

  bool get hasPage => nowItem != null;

  void go(MapFunctionItem item) {
    nowItem = item;
    if (drawerController.nowState == DrawerState.closed) {
      drawerController.open();
      Future.delayed(_drawerAnimationDuration)
          .then((_) => rebuildDrawerAndPage());
    } else {
      rebuildDrawerAndPage();
    }
  }

  void back() {
    nowItem = null;
    onPageDispose?.call();
    rebuildDrawerAndPage();
    if (drawerController.nowState == DrawerState.opened) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        drawerController.close();
        Future.delayed(_drawerAnimationDuration)
            .then((_) => rebuildDrawerAndPage());
      });
    }
  }

  void rebuildDrawerAndPage() {
    drawerSetState(() {}); // drawer rebuild
    rebuild(); // page rebuild (height changed)
  }

  static const _drawerAnimationDuration = Duration(milliseconds: 300);

  BottomDrawer get bottomDrawer => BottomDrawer(
      height: nowItem?.isScrollPage == true
          ? MediaQuery.sizeOf(context).height / 3.6
          : null,
      expandedHeight: 480,
      handleSectionHeight: 20,
      handleColor: colorTheme.secondary,
      backgroundColor: colorTheme.background,
      onReady: (controller) => drawerController = controller,
      onStateChanged: (state) => drawerState = state,
      onHeightChanged: onDrawerHeightChanged,
      resizeAnimationDuration: _drawerAnimationDuration,
      builder: (state, setState, context) {
        drawerSetState = setState;
        return hasPage
            ? selectedPage(state == DrawerState.opened)
            : innerListView(state == DrawerState.closed);
      });

  Widget innerListView(bool isClosed) => Column(children: [
        innerListViewHeader(),
        Expanded(
          flex: isClosed ? 0 : 1,
          child: Padding(
            padding: const EdgeInsets.all(8)
                .copyWith(bottom: 8 + MediaQuery.of(context).padding.bottom),
            child: HalfActionButtonGrid(
                buttons: pages.map((page) {
              if (page.needItemOnTap) {
                page = page.copyWith(
                    onTap: go,
                    onBack: back,
                    drawerController: drawerController);
              }
              return page.getItemWidget(context);
            }).toList()),
          ),
        ),
      ]);

  Widget innerListViewHeader() => Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: colorTheme.onBackground.withOpacity(0.28), width: 0.2)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("지도 기능 둘러보기", style: textTheme.titleLarge),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) =>
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                      color: Platform.isAndroid ? Colors.green : Colors.black,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(children: [
                    Icon(Platform.isAndroid ? Icons.android : Icons.apple,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 2),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: constraints.maxWidth - 32),
                      child: Text(Platform.operatingSystemVersion,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall),
                    ),
                  ])),
            ]),
          ),
        ),
      ]));

  Widget selectedPage(bool canScroll) {
    assert(nowItem != null);
    return nowItem!.getPageWidget(context, canScroll: canScroll);
  }

  bool processWillPop() {
    if (hasPage) {
      back();
      return false;
    } else if (drawerState != DrawerState.closed) {
      drawerController.close();
      return false;
    }
    return true;
  }
}
