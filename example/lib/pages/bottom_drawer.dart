import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bottom_drawer/flutter_bottom_drawer.dart';

import '../design/map_function_item.dart';
import '../design/theme.dart';

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
  final scrollController = ScrollController();

  MapFunctionItem? nowItem;

  bool get hasPage => nowItem != null;

  void go(MapFunctionItem item) {
    nowItem = item;
    rebuildDrawerAndPage();
  }

  void back() {
    nowItem = null;
    onPageDispose?.call();
    rebuildDrawerAndPage();
  }

  void rebuildDrawerAndPage() {
    drawerSetState(() {}); // drawer rebuild
    rebuild(); // page rebuild (height changed)
  }

  BottomDrawer get bottomDrawer => BottomDrawer(
      height: nowItem?.isScrollPage == false ? null : 200,
      expandedHeight: 480,
      handleSectionHeight: 20,
      handleColor: colorTheme.secondary,
      backgroundColor: colorTheme.background,
      onReady: (controller) => drawerController = controller,
      onStateChanged: (state) => drawerState = state,
      onHeightChanged: onDrawerHeightChanged,
      builder: (state, setState, context) {
        drawerSetState = setState;
        return hasPage
            ? selectedPage(state == DrawerState.opened)
            : innerListView(state == DrawerState.opened);
      });

  Widget innerListView(bool canScroll) => Column(children: [
        innerListViewHeader(),
        Expanded(
            child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: Scrollbar(
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      physics: canScroll
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      itemCount: pages.length,
                      itemBuilder: (context, index) {
                        MapFunctionItem page = pages[index];
                        if (page.needItemOnTap) {
                          page = page.copyWith(
                              onTap: go,
                              onBack: back,
                              drawerController: drawerController);
                        }
                        return page.getItemWidget(context);
                      },
                    )))),
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
        const Spacer(),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: kReleaseMode ? colorTheme.primary : colorTheme.secondary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(kReleaseMode ? "Release Mode" : "Debug Mode",
                style: textTheme.labelSmall)),
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
