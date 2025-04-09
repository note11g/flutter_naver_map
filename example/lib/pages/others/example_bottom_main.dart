import 'package:flutter/material.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/pages/others/example_page_data.dart';

class ExampleMain extends StatelessWidget {
  final List<ExamplePageData> pages;

  const ExampleMain({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(
                8) /* padding of all direction + bottomSafeArea */
            .copyWith(bottom: 8 + MediaQuery.paddingOf(context).bottom),
        child: HalfActionButtonGrid(
          buttons: pages.map((page) => page.getItemWidget(context)).toList(),
        ));
  }
}
