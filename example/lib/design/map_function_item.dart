import 'package:flutter/material.dart';

import 'theme.dart';

typedef MapFunctionItemOnTap = void Function(MapFunctionItem item);
typedef MapFunctionItemOnBack = void Function();

class MapFunctionItem {
  final String title;
  final String? description;
  final MapFunctionItemOnTap? onTap;
  final Widget Function(bool canScroll)? page;
  final MapFunctionItemOnBack? onBack;

  MapFunctionItem({
    required this.title,
    this.description,
    this.page,
    required this.onTap,
    this.onBack,
  });

  bool get needItemOnTap => onTap == null;

  Widget getItemWidget(BuildContext context) {
    return InkWell(
        onTap: onTap != null ? () => onTap!.call(this) : null,
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 24, vertical: description != null ? 12 : 20),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    if (description != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: SizedBox(
                              width: double.infinity,
                              child: Text(description!,
                                  style: getTextTheme(context)
                                      .bodyMedium
                                      ?.copyWith(
                                          color:
                                              getColorTheme(context).secondary),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1)))
                  ])),
              const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            ])));
  }

  Widget getPageWidget(BuildContext context, {bool canScroll = true}) {
    assert(page != null);
    return Material(
        color: Colors.transparent,
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            IconButton(
                onPressed: onBack,
                padding: const EdgeInsets.all(16),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
            Text(title, style: getTextTheme(context).titleLarge),
          ]),
          page!(canScroll)
        ]));
  }

  MapFunctionItem copyWith({
    String? title,
    String? description,
    MapFunctionItemOnTap? onTap,
    Widget Function(bool canScroll)? page,
    MapFunctionItemOnBack? onBack,
  }) {
    return MapFunctionItem(
      title: title ?? this.title,
      description: description ?? this.description,
      onTap: onTap ?? this.onTap,
      page: page ?? this.page,
      onBack: onBack ?? this.onBack,
    );
  }
}
